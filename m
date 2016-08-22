Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2A5057CA0
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 23:46:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9590DAC001
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 21:46:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qDzI2iKyevf7NZ54 for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2016 21:46:15 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 45E3B474BA7
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 23:46:15 -0500 (CDT)
Subject: Re: [PATCH v2 3/3] xfs_quota: additional changes to allow use on ext4
References: <1471356998-2876-1-git-send-email-billodo@redhat.com>
	<1471356998-2876-4-git-send-email-billodo@redhat.com>
	<20160822020650.GR19025@dastard>
	<86d459e4-6853-9f3c-3851-3e212f8c7adf@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8c1b4044-ff69-f891-a4f4-b302bd3bfef3@sandeen.net>
Date: Sun, 21 Aug 2016 23:46:14 -0500
MIME-Version: 1.0
In-Reply-To: <86d459e4-6853-9f3c-3851-3e212f8c7adf@sandeen.net>
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

On 8/21/16 10:34 PM, Eric Sandeen wrote:
> On 8/21/16 9:06 PM, Dave Chinner wrote:
>> On Tue, Aug 16, 2016 at 09:16:38AM -0500, Bill O'Donnell wrote:

...

>> static int
>> init_check_command(
>> 	const cmdinfo_t *ct)
>> {
>> 	if (!fspath)
>> 		return 1;
>>
>> 	/* Always run commands that we are told to skip here */
>> 	if (ct->flags & CMD_SKIP_CHECK)
>> 		return 1;
>>
>> 	/* if it's an XFS filesystem, always run the command */
>> 	if (!(fs_path->fs_flags & FS_FOREIGN))
>> 		return 1;
> 
> Sorry for the late review; thanks for getting on it, Dave - but,
> isn't "foreign ok" exactly == "skip check?"
> 
> The only check that gets skipped is the foreign check, so just
> setting FOREIGN_OK seems to accomplish the same thing without
> more flag complexity, no?

Oh, the subliminal brain reminded me that we want to be able to
issue help or quit whether or not we had the "-f" flag, regardless
of the filesystem, and that "foreign" isn't ok unless the -f flag
is set, so we do need a class of "always works" commands.

I guess that was the point of the patch, but I suppose some clarity
in comments or commitlog would help slow people like me.  ;)

Thanks,
-Eric

> Thanks,
> -Eric
> 
> 
>> 	/* If the user specified foreign filesysetms are ok, run it */
>> 	if (foreign_allowed &&
>> 	    (ct->flags & CMD_FLAG_FOREIGN_OK))
>> 		return 1;
>>
>> 	/* foreign filesystem and it's no a valid command! */
>> 	fprintf(stderr, _("%s command is for XFS filesystems only\n"),
>> 			ct->name);
>> 	return 0;
>> }
>>
>> Cheers,
>>
>> Dave.
>>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
