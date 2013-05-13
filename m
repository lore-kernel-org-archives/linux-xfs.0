Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 804517CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 17:15:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25CD9AC001
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 15:15:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ZU6GdBKjzrBCep3G for <xfs@oss.sgi.com>;
	Mon, 13 May 2013 15:15:17 -0700 (PDT)
Message-ID: <519165F2.80902@sandeen.net>
Date: Mon, 13 May 2013 17:15:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair force_geometry
References: <5190DB7F.2050505@tum.de>
In-Reply-To: <5190DB7F.2050505@tum.de>
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
To: benediktibk@aon.at
Cc: Benedikt Schmidt <benedikt.schmidt@tum.de>, xfs@oss.sgi.com

On 5/13/13 7:24 AM, Benedikt Schmidt wrote:
> Hi, currently I'm looking for the correct usage of the force_geometry
> option of xfs_repair. I wasn't able to find more documentation on
> this option beside that it exists. Could please somebody explain it
> to me?
> 
> For a more detailed description of my problem: I've got here a hard
> disk which is dying at the moment, so I copied all the content with
> dd_rescue to a new and bigger one. To use xfs_copy wasn't possible as
> the filesystem was already corrupted. So now I've got nearly
> everything on the second hard disk (dd_rescue could'nt copy something
> around 6 or 7 MB), but I can not mount the filesystem or even run
> xfs_repair on it, as it fails to find a superblock. I think the
> problem lies in the fact that the new disk has a different geometry
> than the previous one.

the geometry in "force_geometry" refers to the filesystem geometry,
not the CHS geometry of your disk.

It's only needed if the fs has only 2 allocation groups and they don't
match, or if the fs has only a single allocation group (and therefore
has nothing to test against).

So I don't think that's the option you need.

I don't know what you copied the fs to, but perhaps you copied the
entire disk, not the partition.  

How did you invoke dd_rescue?

If you dd_rescued to a file, what does:

# file <file you dd'd to>

say?

Or, if you dd_rescued to a device, what does

# file -s <dev you dd'd to>

say?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
