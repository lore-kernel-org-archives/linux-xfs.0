Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p42JW5YU245605 for <xfs@oss.sgi.com>; Mon, 2 May 2011 14:32:05 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC71811BDBEE
	for <xfs@oss.sgi.com>; Mon,  2 May 2011 12:35:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cNGsZdD6R5Faa0U1 for
	<xfs@oss.sgi.com>; Mon, 02 May 2011 12:35:41 -0700 (PDT)
Message-ID: <4DBF0789.3090808@redhat.com>
Date: Mon, 02 May 2011 14:35:37 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [XFS Punch Hole 1/1] XFS Add Punch Hole Testing to FSX
References: <4DBF02FF.608@linux.vnet.ibm.com> <4DBF0498.6070905@redhat.com>
In-Reply-To: <4DBF0498.6070905@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 5/2/11 2:23 PM, Eric Sandeen wrote:
> On 5/2/11 2:16 PM, Allison Henderson wrote:
>> This patch adds punch hole tests to the fsx
>> stress test.  The test is performed through
>> the fallocate call by randomly choosing to
>> use the punch hole flag when running the
>> fallocate test.  Regions that have
>> been punched out should contain zeros, so
>> the expected file contents buffer is updated
>> to contain zeros when a hole is punched out.
> 
> I'll cc: the xfs list since this would live in xfstests.
> 
> Thanks,
> -Eric
> 
>> Signed-off-by: Allison Henderson <achender@us.ibm.com>
>> ---
>> :100644 100644 32cd380... d424941... M	ltp/Makefile
>> :100644 100644 fe072d3... 4f54ef6... M	ltp/fsx.c
>>  ltp/Makefile |    2 +-
>>  ltp/fsx.c    |   73 ++++++++++++++++++++++++++++++++++++++++++++++++---------
>>  2 files changed, 62 insertions(+), 13 deletions(-)
>>
>> diff --git a/ltp/Makefile b/ltp/Makefile
>> index 32cd380..d424941 100644
>> --- a/ltp/Makefile
>> +++ b/ltp/Makefile
>> @@ -27,7 +27,7 @@ LCFLAGS += -DAIO
>>  LLDLIBS += -laio -lpthread
>>  endif
>>  
>> -ifeq ($(HAVE_FALLOCATE), true)
>> +ifeq ($(HAVE_FALLOCATE), yes)

argh I ended up with 2 fallocate tests in aclocal.m4, need to tidy that up, I'll do that in a separate patch.

>>  LCFLAGS += -DFALLOCATE
>>  endif
>>  
>> diff --git a/ltp/fsx.c b/ltp/fsx.c
>> index fe072d3..4f54ef6 100644
>> --- a/ltp/fsx.c
>> +++ b/ltp/fsx.c
>> @@ -207,7 +207,8 @@ logdump(void)
>>  {
>>  	int	i, count, down;
>>  	struct log_entry	*lp;
>> -	char *falloc_type[3] = {"PAST_EOF", "EXTENDING", "INTERIOR"};
>> +	char *falloc_type[4] = {"PAST_EOF", "EXTENDING", "INTERIOR",
>> +				"PUNCH_HOLE"};
>>  
>>  	prt("LOG DUMP (%d total operations):\n", logcount);
>>  	if (logcount < LOGSIZE) {
>> @@ -791,7 +792,11 @@ dofallocate(unsigned offset, unsigned length)
>>  {
>>  	unsigned end_offset;
>>  	int keep_size;
>> -
>> +	int max_offset = 0;
>> +	int max_len = 0;
>> +	int punch_hole = 0;
>> +	int mode = 0;
>> +	char *op_name;
>>          if (length == 0) {
>>                  if (!quiet && testcalls > simulatedopcount)
>>                          prt("skipping zero length fallocate\n");
>> @@ -799,11 +804,31 @@ dofallocate(unsigned offset, unsigned length)
>>                  return;
>>          }
>>  
>> +#ifdef FALLOC_FL_PUNCH_HOLE
>> +	punch_hole = random() % 2;
>> +	/* Keep size must be set for punch hole */
>> +	if (punch_hole) {
>> +		keep_size = 1;
>> +		mode = FALLOC_FL_PUNCH_HOLE;
>> +	} else
>> +		keep_size = random() % 2;
>> +#else
>>  	keep_size = random() % 2;
>> +#endif
>> +
>> +	if (keep_size)
>> +		mode |= FALLOC_FL_KEEP_SIZE;
>> +
>> +	if (punch_hole && file_size <= (loff_t)offset) {
>> +		if (!quiet && testcalls > simulatedopcount)
>> +			prt("skipping hole punch off the end of the file\n");
>> +		log4(OP_SKIPPED, OP_FALLOCATE, offset, length);
>> +		return;
>> +	}
>>  
>>  	end_offset = keep_size ? 0 : offset + length;
>>  
>> -	if (end_offset > biggest) {
>> +	if ((end_offset > biggest) && !punch_hole) {
>>  		biggest = end_offset;
>>  		if (!quiet && testcalls > simulatedopcount)
>>  			prt("fallocating to largest ever: 0x%x\n", end_offset);
>> @@ -811,13 +836,15 @@ dofallocate(unsigned offset, unsigned length)
>>  
>>  	/*
>>  	 * last arg:
>> -	 * 	1: allocate past EOF
>> -	 * 	2: extending prealloc
>> -	 * 	3: interior prealloc
>> +	 *      0: allocate past EOF
>> +	 *      1: extending prealloc
>> +	 *      2: interior prealloc
>> +	 *      3: punch hole
>>  	 */
>> -	log4(OP_FALLOCATE, offset, length, (end_offset > file_size) ? (keep_size ? 1 : 2) : 3);
>> +	log4(OP_FALLOCATE, offset, length, punch_hole ? 3 :
>> +			(end_offset > file_size) ? (keep_size ? 0 : 1) : 2);
>>  
>> -	if (end_offset > file_size) {
>> +	if (((loff_t)end_offset > file_size) && !punch_hole) {
>>  		memset(good_buf + file_size, '\0', end_offset - file_size);
>>  		file_size = end_offset;
>>  	}
>> @@ -827,13 +854,35 @@ dofallocate(unsigned offset, unsigned length)
>>  	
>>  	if ((progressinterval && testcalls % progressinterval == 0) ||
>>  	    (debug && (monitorstart == -1 || monitorend == -1 ||
>> -		      end_offset <= monitorend)))
>> -		prt("%lu falloc\tfrom 0x%x to 0x%x\n", testcalls, offset, length);
>> -	if (fallocate(fd, keep_size ? FALLOC_FL_KEEP_SIZE : 0, (loff_t)offset, (loff_t)length) == -1) {
>> -	        prt("fallocate: %x to %x\n", offset, length);
>> +		      end_offset <= monitorend))) {
>> +#ifdef FALLOC_FL_PUNCH_HOLE
>> +		op_name = (mode & FALLOC_FL_PUNCH_HOLE) ?
>> +			"punch hole" : "falloc";
>> +#else
>> +		op_name = "falloc";
>> +#endif
>> +		prt("%lu %s\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
>> +			op_name, offset, offset+length, length);
>> +	}
>> +	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
>> +#ifdef FALLOC_FL_PUNCH_HOLE
>> +		op_name = (mode & FALLOC_FL_PUNCH_HOLE) ?
>> +			"punch hole" : "fallocate";
>> +#else
>> +		op_name = "fallocate";
>> +#endif
>> +
>> +		prt("%s: %x to %x\n", op_name, offset, length);
>>  		prterr("dofallocate: fallocate");
>>  		report_failure(161);
>>  	}
>> +
>> +	if (punch_hole) {
>> +		max_offset = offset < file_size ? offset : file_size;
>> +		max_len = max_offset + length <= file_size ? length :
>> +				file_size - max_offset;
>> +		memset(good_buf + max_offset, '\0', max_len);
>> +	}
>>  }
>>  #else
>>  void
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
