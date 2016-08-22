Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C385C7CA0
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 22:34:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6A5338F8040
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 20:34:42 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id o1C3DTEVN7CPTb4f for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2016 20:34:39 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 9A099474BA7
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 22:34:38 -0500 (CDT)
Subject: Re: [PATCH v2 3/3] xfs_quota: additional changes to allow use on ext4
References: <1471356998-2876-1-git-send-email-billodo@redhat.com>
	<1471356998-2876-4-git-send-email-billodo@redhat.com>
	<20160822020650.GR19025@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <86d459e4-6853-9f3c-3851-3e212f8c7adf@sandeen.net>
Date: Sun, 21 Aug 2016 22:34:38 -0500
MIME-Version: 1.0
In-Reply-To: <20160822020650.GR19025@dastard>
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
To: xfs@oss.sgi.com

On 8/21/16 9:06 PM, Dave Chinner wrote:
> On Tue, Aug 16, 2016 at 09:16:38AM -0500, Bill O'Donnell wrote:
>> Further changes to allow xfs_quota to be used on foreign filesystem(s)
>> (e.g. ext4) for project quota testing in xfstests.
>>
>> Add CMD_FLAG_GENERIC to enable generic xfs_quota commands (help and
>> quit) when xfs_quota is run on foreign filesystems.
>>
>> Use CMD_FLAG_FOREIGN_OK on commands suitable for foreign filesystems.
>>
>> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
>> ---
>>  include/command.h | 1 +
>>  libxcmd/help.c    | 3 ++-
>>  libxcmd/quit.c    | 3 ++-
>>  quota/init.c      | 3 ++-
>>  4 files changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/command.h b/include/command.h
>> index 81d5a4d..1c2898a 100644
>> --- a/include/command.h
>> +++ b/include/command.h
>> @@ -22,6 +22,7 @@
>>  
>>  #define CMD_FLAG_GLOBAL		(1<<31)	/* don't iterate "args" */
>>  #define CMD_FLAG_FOREIGN_OK	(1<<30)	/* command not restricted to XFS */
>> +#define CMD_FLAG_GENERIC	(1<<29) /* command is generic (help, quit) */
> 
> I don't think this belongs in include/command.h - it's an xfs_quota
> specific behaviour so I'd put this in quota/init.h:
> 
> #define CMD_SKIP_CHECK	(1<<0)	/* command is always run */
> 
>> diff --git a/quota/init.c b/quota/init.c
>> index d5d80c2..85931bf 100644
>> --- a/quota/init.c
>> +++ b/quota/init.c
>> @@ -104,7 +104,8 @@ init_check_command(
>>  	const cmdinfo_t	*ct)
>>  {
>>  	if (fs_path &&
>> -	    !(ct->flags & CMD_FLAG_FOREIGN_OK) &&
>> +	    !((ct->flags & CMD_FLAG_FOREIGN_OK) && foreign_allowed) &&
>> +	    !(ct->flags & CMD_FLAG_GENERIC) &&
>>  	     (fs_path->fs_flags & FS_FOREIGN)) {
> 
> This is now sufficiently confusing that it needs to be reworked to
> make the logic clear and easily commented. i.e. something like this:
> 
> static int
> init_check_command(
> 	const cmdinfo_t *ct)
> {
> 	if (!fspath)
> 		return 1;
> 
> 	/* Always run commands that we are told to skip here */
> 	if (ct->flags & CMD_SKIP_CHECK)
> 		return 1;
> 
> 	/* if it's an XFS filesystem, always run the command */
> 	if (!(fs_path->fs_flags & FS_FOREIGN))
> 		return 1;

Sorry for the late review; thanks for getting on it, Dave - but,
isn't "foreign ok" exactly == "skip check?"

The only check that gets skipped is the foreign check, so just
setting FOREIGN_OK seems to accomplish the same thing without
more flag complexity, no?

Thanks,
-Eric


> 	/* If the user specified foreign filesysetms are ok, run it */
> 	if (foreign_allowed &&
> 	    (ct->flags & CMD_FLAG_FOREIGN_OK))
> 		return 1;
> 
> 	/* foreign filesystem and it's no a valid command! */
> 	fprintf(stderr, _("%s command is for XFS filesystems only\n"),
> 			ct->name);
> 	return 0;
> }
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
