Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 54CD229DF8
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 16:48:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E5CC7AC002
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 14:48:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jTHFDGAE2LzHNiit for <xfs@oss.sgi.com>;
	Mon, 06 May 2013 14:48:40 -0700 (PDT)
Message-ID: <51882537.6070904@sandeen.net>
Date: Mon, 06 May 2013 16:48:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Internal error xfs_sb_read_verify at line 726
References: <20130506112717.GA502@x4> <5187E290.8090109@sandeen.net>
	<20130506183020.GA513@x4> <51880121.8000001@sandeen.net>
	<20130506192629.GA503@x4> <5188074F.2090500@sandeen.net>
	<20130506195521.GB503@x4> <51881750.3090309@sandeen.net>
In-Reply-To: <51881750.3090309@sandeen.net>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: xfs@oss.sgi.com

On 5/6/13 3:49 PM, Eric Sandeen wrote:
...

> Interesting, so [mount] really does try to mount by successive fs types.
> 
> I wonder when that behavior changed (my util-linux-ng 2.17 on RHEL6 doesn't do this)
> 
> I'll take a look.

Just to satisfy my curiosity:

commit c6c98f93f5e4b3fb9a8b51ed2ef9967793df7b1c
Author: Karel Zak <kzak@redhat.com>
Date:   Mon Mar 15 13:46:43 2010 +0100

    mount: report ambivalent FS detection, improve brute force detection
    
    The ambivalent probing result should be properly reported and user
    should be informed that the problem is possible to bypass by "-t
    <type>" or resolved by wipefs(8).
    
    The mount(8) command uses a brute force stage (calls mount(2) for all
    /{proc,etc}/fylesystems) if there is not any other way how to detect
    the filesystem type. The brute force stage should not be restricted by
    libblkid. It's possible that libblkid is not able to detect slightly
    corrupted filesystem, but kernel is able to mount such filesystem.
    
    Note that the brute force stage should not be used if libblkid returns
    ambivalent probing result. In this case user's intervention is required
    (e.g. mount -t <type>).
    
    Reported-by: Mike Frysinger <vapier@gentoo.org>
    Signed-off-by: Karel Zak <kzak@redhat.com>

So we're getting into xfs mount with an actual "-t xfs" equivalent,
and not going down the "silent" paths.

I'll send the patch.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
