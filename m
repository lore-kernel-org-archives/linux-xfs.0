Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o41Db8Zx255665 for <xfs@oss.sgi.com>; Sat, 1 May 2010 08:37:08 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D859304E20
	for <xfs@oss.sgi.com>; Sat,  1 May 2010 06:39:09 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org
	(173-164-175-65-SFBA.hfc.comcastbusiness.net [173.164.175.65])
	by cuda.sgi.com with ESMTP id CWrAAYtC3999NOw6 for
	<xfs@oss.sgi.com>; Sat, 01 May 2010 06:39:09 -0700 (PDT)
Message-ID: <4BDC2EEC.9080808@tlinx.org>
Date: Sat, 01 May 2010 06:38:52 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: Building XFSDump but missing uuid development package
References: <53964.41414.qm@web180401.mail.gq1.yahoo.com>
In-Reply-To: <53964.41414.qm@web180401.mail.gq1.yahoo.com>
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
To: Peter Shuere <petershuere@yahoo.com>
Cc: xfs@oss.sgi.com



Peter Shuere wrote:
> Hi,
> 
> I am trying to build the XFS utility, but during the build-process, I ran into a problem saying that I need the UUID development package to make the build complete. I am using OpenSUSE 11.2, where should I get the copy of the uuid-devel source (or binary, whichever one that works).
(On SuSE 11.2:)
> zypper se uuid 
Loading repository data...
Reading installed packages...

S | Name                | Summary                                   | Type      
--+---------------------+-------------------------------------------+-----------
i | libuuid-devel       | Development files for libuuid1            | package   
  | libuuid-devel-32bit | Development files for libuuid1            | package   
i | libuuid1            | Library to generate UUIDs                 | package   
i | libuuid1-32bit      | Library to generate UUIDs                 | package   
  | perl-Data-UUID      | Perl extension for generating Globally/-> | package   
  | perl-Data-UUID      | Perl extension for generating Globally/-> | srcpackage
  | uuidd               | Utilities for the Second Extended File -> | package   
---
Does libuuid-devel not work for you?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
