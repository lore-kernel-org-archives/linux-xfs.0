Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 13B807F50
	for <xfs@oss.sgi.com>; Fri, 13 Mar 2015 17:48:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E454B304039
	for <xfs@oss.sgi.com>; Fri, 13 Mar 2015 15:48:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KwZWFJefD43Lg857 for <xfs@oss.sgi.com>;
	Fri, 13 Mar 2015 15:48:16 -0700 (PDT)
Message-ID: <55036930.5020204@sandeen.net>
Date: Fri, 13 Mar 2015 17:48:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_db: Allow writes of corrupted data by optionally
	skipping write verifiers
References: <54F8CA08.303@redhat.com> <20150313134317.GC2678@laptop.bfoster>
In-Reply-To: <20150313134317.GC2678@laptop.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 3/13/15 8:43 AM, Brian Foster wrote:
> On Thu, Mar 05, 2015 at 03:26:32PM -0600, Eric Sandeen wrote:
>> Being able to write corrupt data is handy if we wish to test
>> repair against specific types of corruptions.
>>
>> Add a "-c" option to the write command which allows this.
>>
>> Note that this also skips CRC updates; it's not currently possible
>> to write invalid data with a valid CRC; CRC recalculation is
>> intertwined with validation.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/db/crc.c b/db/crc.c
>> index ad46c3f..861086a 100644
>> --- a/db/crc.c
>> +++ b/db/crc.c
> 
> This depends on the previous crc command which isn't merged yet. It
> might be worth it to include that again here so it hopefully gets picked
> up.
> 
>> @@ -58,13 +58,6 @@ crc_help(void)
>>  
>>  }
>>  
>> -void
>> -xfs_dummy_verify(
>> -	struct xfs_buf *bp)
>> -{
>> -	return;
>> -}
>> -
>>  static int
>>  crc_f(
>>  	int		argc,
>> diff --git a/db/crc.h b/db/crc.h
>> index 80ecec3..9f44615 100644
>> --- a/db/crc.h
>> +++ b/db/crc.h
>> @@ -20,4 +20,3 @@ struct field;
>>  
>>  extern void	crc_init(void);
>>  extern void	crc_struct(const field_t *fields, int argc, char **argv);
>> -extern void	xfs_dummy_verify(struct xfs_buf *bp);
>> diff --git a/db/io.c b/db/io.c
>> index eb3daa1..2d18d56 100644
>> --- a/db/io.c
>> +++ b/db/io.c
>> @@ -458,6 +458,13 @@ write_cur_bbs(void)
>>  }
>>  
>>  void
>> +xfs_dummy_verify(
>> +	struct xfs_buf *bp)
>> +{
>> +	return;
>> +}
>> +
>> +void
>>  write_cur(void)
>>  {
>>  	int skip_crc = (iocur_top->bp->b_ops->verify_write == xfs_dummy_verify);
>> diff --git a/db/io.h b/db/io.h
>> index 71082e6..31d96b4 100644
>> --- a/db/io.h
>> +++ b/db/io.h
>> @@ -63,6 +63,7 @@ extern void	set_cur(const struct typ *t, __int64_t d, int c, int ring_add,
>>  			bbmap_t *bbmap);
>>  extern void     ring_add(void);
>>  extern void	set_iocur_type(const struct typ *t);
>> +extern void	xfs_dummy_verify(struct xfs_buf *bp);
>>  
>>  /*
>>   * returns -1 for unchecked, 0 for bad and 1 for good
>> diff --git a/db/write.c b/db/write.c
>> index a0f14f4..a01c25a 100644
>> --- a/db/write.c
>> +++ b/db/write.c
>> @@ -38,7 +38,7 @@ static int	write_f(int argc, char **argv);
>>  static void     write_help(void);
>>  
>>  static const cmdinfo_t	write_cmd =
>> -	{ "write", NULL, write_f, 0, -1, 0, N_("[field or value]..."),
>> +	{ "write", NULL, write_f, 0, -1, 0, N_("[-c] [field or value]..."),
>>  	  N_("write value to disk"), write_help };
>>  
>>  void
>> @@ -79,6 +79,7 @@ write_help(void)
>>  "  String mode: 'write \"This_is_a_filename\" - write null terminated string.\n"
>>  "\n"
>>  " In data mode type 'write' by itself for a list of specific commands.\n\n"
>> +" Specifying the -c option will allow writes of invalid (corrupt) data.\n\n"
>>  ));
>>  
>>  }
>> @@ -90,6 +91,9 @@ write_f(
>>  {
>>  	pfunc_t	pf;
>>  	extern char *progname;
>> +	int c;
>> +	int corrupt = 0;		/* Allow write of corrupt data; skip verification */
>> +	const struct xfs_buf_ops *stashed_ops = NULL; 
> 
> Trailing space here.
> 
>>  
>>  	if (x.isreadonly & LIBXFS_ISREADONLY) {
>>  		dbprintf(_("%s started in read only mode, writing disabled\n"),
>> @@ -109,12 +113,36 @@ write_f(
>>  		return 0;
>>  	}
>>  
>> -	/* move past the "write" command */
>> -	argc--;
>> -	argv++;
>> +	if (argc) while ((c = getopt(argc, argv, "c")) != EOF) {
> 
> Isn't argc always going to be non-zero at this point (e.g., argv[0] ==
> "write")?

Hm, yeah, not sure if that was a thinko or a typo, thanks.

(hm, db's bmap_f does the same thing, I might have just blindly copied that)

>> +	if (corrupt) {
>> +		struct xfs_buf_ops nowrite_ops;
>> +
> 
> This may not be an explicit failure, but I'd rather not define this on
> the stack in the local scope of this branch and then implicitly use it
> outside of that scope. Could we move the definition and possibility the
> initialization to the top of the function?

*nod* I'll fix that too.

I'll send the crc patch & this in another 2-patch series (though I am wondering
if the crc patch is needed, if we're able to write bad data; it kind of achieves
the same goal - thoughts?)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
