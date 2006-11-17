Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Nov 2006 17:07:46 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAH17aaG012051
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 17:07:38 -0800
Date: Fri, 17 Nov 2006 11:08:40 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
Message-ID: <BB70F203E29C2D37A2F727C8@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <455CB54F.8080901@sandeen.net>
References: <455CB54F.8080901@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Hi Eric,

--On 16 November 2006 1:00:31 PM -0600 Eric Sandeen <sandeen@sandeen.net> wrote:

> see also https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=212201
>
> Bugzilla Bug 212201: Cannot build sysem with XFS file system.
>
> I turned on attr2 in FC6 at nathan's suggestion, for selinux goodness
> with more efficient xattr space usage.
>
> But, many reports that this was totally broken in fc6, on x86_64.
>
> Install went ok, but on reboot the filesystem was found to be corrupt.
>
> The filesystem was also found to be marked w/ attr1, not attr2....
>
> If you do a fresh mkfs.xfs on x86_64, with -i attr=2, and dump out the
> superblock (or look at it with xfs_db) you will find that although the
> versionnum says that there is a morebits bit, the features2 flag is 0.
>
> if you dd/hexdump the superblock, you will find the attr2 flag, but at
> the wrong offset.
>
> This is because the xfs_sb_t struct is padded out to 64 bits on 64-bit
> arches,

This actually came up when I wrote xfstests/122.
It looks at sizes of various ondisk structures and for some of them it
print's out the offsets of the fields.
I noticed that the xfs_sb_t was a different size on 32bit and 64 bit
and so printed out all the field offsets.
They are all the same (on different word sizes)
and so the only difference is that the last field
will be padded out on a 64 bit platform as you noticed.
I couldn't really see a problem with that.
And discussed it with Nathan at the time.

> and the xfs_xlatesb() routine and xfs_sb_info[] array take this
> padding to mean that the last item is 4 bytes bigger than it is, and
> treats sb_features2 as 8 bytes not four.  This then gets endian-flipped out...
>

Well there is a bug in the sb endian translation code then or its setup.
All the field accesses should be correct, no?

I can't see why it needs to be packed or padded if it's just implicit extra padding
after the end of the last field.
Am I missing something?

Let me look into this a bit more :)

--Tim
