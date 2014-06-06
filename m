Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6EE3F7F3F
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 10:27:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 042668F8037
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 08:27:34 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5xNtWHu2ua5Zzyv5 for <xfs@oss.sgi.com>;
	Fri, 06 Jun 2014 08:27:29 -0700 (PDT)
Message-ID: <5391DDE4.90007@sandeen.net>
Date: Fri, 06 Jun 2014 10:27:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2 V2] mkfs.xfs: don't call blkid_get_topology on regular
	files
References: <53852A05.5040006@redhat.com> <5390C1B7.7050106@sandeen.net>
	<20140606152059.GB3048@laptop.bfoster>
In-Reply-To: <20140606152059.GB3048@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 6/6/14, 10:21 AM, Brian Foster wrote:
> On Thu, Jun 05, 2014 at 02:15:03PM -0500, Eric Sandeen wrote:
>> If we encounter a target that's really a regular file,
>> even without "-d file..." on the cmdline, call
>> platform_findsizes() instead of blkid_get_topology to
>> try to discover the "sector size" via the fsgeom() call.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> V2: Lose local "isa_file" flag, just switch based on 
>> (xi->disfile) or (stat works & S_ISREG)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 188b6b3..3b8bf67 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -456,9 +456,25 @@ static void get_topology(
>>  	struct fs_topology	*ft,
>>  	int			force_overwrite)
>>  {
>> -	if (!xi->disfile) {
>> -		const char *dfile = xi->volname ? xi->volname : xi->dname;
>> +	struct stat statbuf;
>> +	char *dfile = xi->volname ? xi->volname : xi->dname;
>>  
>> +	/*
>> +	 * Don't call blkid for topology if this is a "-d file" target, or
>> +	 * if we've simply been pointed at a regular file.  platform_findsizes
>> +	 * will attempt to find the underlying sector size of the host fs.
>> +	 */
>> +	if (xi->disfile ||
>> +	    (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode))) {
>> +		int fd;
>> +		long long dummy;
>> +
>> +		fd = open(dfile, O_RDONLY);
>> +		if (fd >= 0) {
>> +			platform_findsizes(dfile, fd, &dummy, &ft->lsectorsize);
>> +			close(fd);
>> +		}
> 
> The patch looks fine:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> It does look like we'd still be susceptible to error in a situation
> where the file hasn't been created yet (which would occur in
> libxfs_init()).

Hm, let's see - the only way to have mkfs create the file is with the
-d file,name=foo,size=bar invocation.

Sprinkling some printf's into the if/else above, I see:

# rm -f testfile
# mkfs/mkfs.xfs -dfile,name=testfile,size=1g
** doing platform_findsizes **
meta-data=testfile               isize=256    agcount=4, agsize=65536 blks
...

so it looks like the file does get created before we get here.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
