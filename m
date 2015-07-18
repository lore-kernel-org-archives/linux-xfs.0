Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C849F7F61
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2015 09:16:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 54020AC007
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2015 07:16:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id hzBekERhBPcI0oik for <xfs@oss.sgi.com>;
	Sat, 18 Jul 2015 07:16:43 -0700 (PDT)
Message-ID: <55AA5FCE.4080702@sandeen.net>
Date: Sat, 18 Jul 2015 10:16:46 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS File system in trouble
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>
In-Reply-To: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>
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
To: "Rhorer, Leslie" <Leslie.Rhorer@level3.com>, "'lrhorer@mygrande.net'" <lrhorer@mygrande.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 7/17/15 9:46 PM, Rhorer, Leslie wrote:
> I have a 24T XFS file system that is very sick, and seemingly getting
> sicker. I believe it to be the file system itself. I have replaced
> the RAID chassis, the OS, the cables, the drive controller, and most
> of the drives. Re-syncing the RAID array complete in a reasonable
> time, given the size of the array, and reports no mismatches.
> Xfs_repair completes, usually with no errors found, or sometimes one
> or two errors. Some commands, like a df, are now hanging. Writes are
> often failing with I/O errors. I haven't found any amount of obvious
> file corruption, but performing a CRC check using md5sum, md6sum,
> sha256sum, etc., come up with different values every time they are
> run on many large files. What can I do to try to rectify this?

If writes fail with I/O errors, that should show up in dmesg, but I don't
see any such messages.

What did repair find?

Not a lot to go on from the above narrative, I'm afraid.  What large
files are those?  I presume that you are sure they should not be changing?

Thanks for all the info below...

>From the dmesg, every stuck process is stuck on nfs - doesn't look xfs
related at all.

Doesn't seem like an xfs problem, TBH, but maybe you can provide xfs_repair
output and/or dmesg when writes fail, that might offer a clue.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
