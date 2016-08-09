Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 095157CA0
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 09:51:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CCEA1304053
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 07:51:14 -0700 (PDT)
Received: from smtp1.cc.ic.ac.uk (smtp1.cc.ic.ac.uk [155.198.5.155]) by
	cuda.sgi.com with ESMTP id bR2qv7vLGEvEUugi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2016 07:51:12 -0700 (PDT)
Received: from cloud-vm-46-210.doc.ic.ac.uk ([146.169.46.210] helo=ic)
	by smtp1.cc.ic.ac.uk with esmtpsa
	(TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (Exim 4.86)
	(envelope-from <lin.wei15@imperial.ac.uk>) id 1bX8N5-0007Hm-Es
	for xfs@oss.sgi.com; Tue, 09 Aug 2016 15:51:11 +0100
Date: Tue, 9 Aug 2016 15:50:47 +0100
From: Wei Lin <lin.wei15@imperial.ac.uk>
Subject: Question on migrating data between PVs in xfs
Message-ID: <20160809145046.GB5583@ic>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi there,

I am working on an xfs based project and want to modify the allocation
algorithm, which is quite involved. I am wondering if anyone could help
with this.

The high level goal is to create xfs agains multiple physical volumes,
allow user to specify the target PV for files, and migrate files
automatically.

I plan to implement the user interface with extended attributes, but am
now stuck with the allocation/migration part. Is there a way to make xfs
respect the attribute, i.e. only allocate blocks/extents from the target
PV specified by user?

Any suggestion would be highly appreciated.

Cheers,
-- 
Wei Lin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
