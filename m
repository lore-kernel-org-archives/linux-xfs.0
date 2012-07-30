Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6UM84gk096723 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 17:08:04 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	XueGDDQkp6lvOfRc for <xfs@oss.sgi.com>;
	Mon, 30 Jul 2012 15:08:02 -0700 (PDT)
Date: Tue, 31 Jul 2012 08:07:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair no modify output
Message-ID: <20120730220759.GJ2877@dastard>
References: <769346391.171271.1343664034505.JavaMail.open-xchange@oxwebmail.registrar-servers.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <769346391.171271.1343664034505.JavaMail.open-xchange@oxwebmail.registrar-servers.com>
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
To: "jamie@x-edit.co.uk" <jamie@x-edit.co.uk>
Cc: xfs@oss.sgi.com

On Mon, Jul 30, 2012 at 06:00:34PM +0200, jamie@x-edit.co.uk wrote:
> Hi List,
> Sorry for the stupid question, just wanted a quick clarification on the
> following excerpts from an xfs_repair no modify.
> 
> # xfs_repair -nv /dev/sdc1
.....
> entry "YYYY" in dir 4294967424 points to an already connected directory inode 145
>         would clear entry "YYYY"
......
> disconnected dir inode 4294967424, would move to lost+found
......
> Does this in effect mean that the file YYYY will end up and lost+found

Yes.

> and
> directory (and its contents) will end up in lost+found.

Assuming you mean directory entry XXXX, no.

> Namely easy enough to move back. Or will the contents of XXXX be lost?

XXXX was an invalid directory entry. It got removed from the
directory, and the directory is otherwise unmodified. FWIW, it was
on inode 128, so it's probably an entry in the root directory....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
