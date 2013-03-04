Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 06E1C803D
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 06:47:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E975A8F8037
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 04:47:35 -0800 (PST)
Received: from mail-da0-f47.google.com (mail-da0-f47.google.com
	[209.85.210.47]) by cuda.sgi.com with ESMTP id PwWmm40RjtEjt8F3
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Mar 2013 04:47:34 -0800 (PST)
Received: by mail-da0-f47.google.com with SMTP id s35so2525728dak.6
	for <xfs@oss.sgi.com>; Mon, 04 Mar 2013 04:47:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51312C73.5060203@sandeen.net>
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<5131283F.8030704@sandeen.net> <20130301223116.GE23616@dastard>
	<51312C73.5060203@sandeen.net>
From: Ole Tange <tange@binf.ku.dk>
Date: Mon, 4 Mar 2013 13:47:14 +0100
Message-ID: <CANU9nT=ALsO3gegWP8vfmYO=CzgPPTRewAfZPYn_en-c2T8ayA@mail.gmail.com>
Subject: Re: xfs_repair segfaults
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, Mar 1, 2013 at 11:32 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> Ole, you can xfs_mdrestore your metadump image and run test repairs on the result,
> if you want a more realistic "dry run" of what repair would do.

I have never run xfs_mdrestore before.

>From the man page:

       xfs_mdrestore should not be used to restore metadata onto an
existing filesystem unless you are completely certain the  target  can
 be destroyed.

It is unclear to me if you are suggesting me to do:

  xfs_mdrestore the-already-created-dump /dev/md5p1

followed by xfs_repair. Or if you want me to restore the metadata on
another 100 TB partition (I do not have that available).

Maybe you have a trick so that it can be restored on some smaller
block device, so I do not need the 100 TB partition, but I will still
be able to see how many files are being removed? If you have such a
trick, consider including it in the manual.

Also I would love if xfs_repair had an option to copy the changed
sectors to a file, so it would be easy to revert. E.g:

  xfs_repair --backup backup.file /dev/sda1

and if the repair did not work out, then you could revert using:

  xfs_repair --revert backup.file /dev/sda1

and be back at your starting state.


/Ole

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
