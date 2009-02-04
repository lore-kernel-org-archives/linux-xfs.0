Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n14K55OQ170231 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 14:05:05 -0600
Message-ID: <4989F4C2.3030305@sgi.com>
Date: Thu, 05 Feb 2009 07:04:18 +1100
From: Mark Goodwin <markgw@sgi.com>
MIME-Version: 1.0
Subject: Re: IMPORTANT: XFS Documentation
References: <1231946704.3929.36.camel@localhost.localdomain>
	<20090120160346.GJ17616@sgi.com>
	<1232480744.23291.101.camel@localhost.localdomain>
	<20090128202715.GR16689@sgi.com>
	<1233175168.25011.155.camel@localhost.localdomain>
	<20090204183603.GA26714@sgi.com>
In-Reply-To: <20090204183603.GA26714@sgi.com>
Reply-To: markgw@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: John Hesterberg <jh@sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, SGI Engineering Interfaces to Red Hat <redhat-interface@sgi.com>, Marizol Martinez <martinez@redhat.com>, Tony Ernst <tee@sgi.com>, George Beshers <gbeshers@sgi.com>, xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>, Gary Hagensen <gwh@sgi.com>, Ric Wheeler <rwheeler@redhat.com>



John Hesterberg wrote:
> FYI, this just happened internally:
>
>     ==========================
>     ADDITIONAL INFORMATION (TAKE)
>     From: mark goodwin <markgw@sgi.com>
>     Date: Feb 04 2009 02:34:02AM
>     ==========================
>
>     add Copyright using Creative Commons Attribute Share Alike license,
>     as approved by the OSRB for release to oss.sgi.com
>     ...
>     xfsdocs/xfs-website/training/docs/xfs_lab_01_build.doc - 1.3 - changed
>     ...
>
> Just wanted you to know this is still in process and not
> forgotten, since I hadn't seen any other communication about it
> since last week.
>

Sorry for the delay - the lawyers were pondering the GNU FDL Vrs the
Creative Commons license (and settled on the latter). So now that's 
resolved,
I've updated the copyrights in the doc sources and put them in a git tree:

	git://oss.sgi.com/xfs/cmds/xfsdocs.git

This repository is XFS group writable on oss.sgi.com. The directory 
structure
corresponds to (a subset of) the internal ptools tree below 
xfs-cmds/xfsdocs.
Since the files in this repository are binary, you'll need to co-ordinate
check-out/check-in to avoid merge failures (git handles binaries but 
can't merge
them). I think Eric and/or others inside Redhat will have the first go 
at it :)
I also regenerated the PDFs and committed them too since they're also 
present
in the internal ptools tree.

Thanks
-- Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
