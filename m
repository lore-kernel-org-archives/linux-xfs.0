Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0FF007F3F
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 16:31:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9166EAC008
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 14:31:01 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id MHXYayH7v2itdmD2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Jul 2013 14:31:00 -0700 (PDT)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id
	r6NLUtHY089488 for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 14:30:58 -0700
Message-ID: <51EEF60D.6080102@tlinx.org>
Date: Tue, 23 Jul 2013 14:30:53 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: design mismatch(flaw): 2 utils old & new don't provide current
	functionality nor all of needed...
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
To: xfs-oss <xfs@oss.sgi.com>



The attrib command's "list" option is not considered supported, yet it
works.  The alternative to the unsupported list command is using getfattr.
However, getfattr doesn't support listing attributes and their lengths,
nor does it support the Root and Security attribute spaces.  I.e. getfattr
is inadequate to replace the unsupported attrib command.

	Given the above, the attrib command should be reconsidered for
support, or the getfattr command should be enhanced to provide the missing
functionality (no major preference on my part), but as it is we have two
utils that taken together, "do not support" functionality that is already
present (as well as missing functionality).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
