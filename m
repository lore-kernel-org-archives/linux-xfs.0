Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D96467F37
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 10:44:23 -0500 (CDT)
Date: Thu, 28 Mar 2013 10:44:23 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: oops from deliberate block trashing (of course!)
Message-ID: <20130328154423.GV22182@sgi.com>
References: <CAJzLF9nPt9aOrH+Dj12b5os74XT8ke9g4G=DA9xgR0AyehvaBA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJzLF9nPt9aOrH+Dj12b5os74XT8ke9g4G=DA9xgR0AyehvaBA@mail.gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

Hey Michael,

On Thu, Mar 28, 2013 at 01:18:24AM -0400, Michael L. Semon wrote:
> Hi!  This report was requested by Dave because I was praising
> xfs_repair and didn't fully describe the problem that xfs_repair was
> repairing.  Blame me if this is a bad bug report or a matter of XFS
> just doing its job.
> 
> I'm trying to come up with a fair FS-agnostic test to corrupt bytes
> and see how file systems and recovery tools respond after that.

Great bug report!  It's really neat that you're doing this.  ;)

You might be able to find a FS-agnostic fuzzer by doing a search for
'filesystem fuzzer'.  It's not an area that I've explored much myself, so I'm
just throwing that out there.  e.g.
https://ext4.wiki.kernel.org/index.php/Filesystem_Testing_Tools/mangle.c

Nice work!

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
