Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 03:01:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m37A1A55003485
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 03:01:11 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B173755B08
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2008 03:01:47 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id cyr5keZKHrDf4Q0q for <xfs@oss.sgi.com>; Mon, 07 Apr 2008 03:01:47 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m37A1eF3012041
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 12:01:41 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m37A1ehq012039
	for xfs@oss.sgi.com; Mon, 7 Apr 2008 12:01:40 +0200
Date: Mon, 7 Apr 2008 12:01:40 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: new xfsqa mismatches
Message-ID: <20080407100140.GA11891@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

103:

 - output mismatch (see 103.out.bad)
7c7
< ln: creating symbolic link `SCRATCH_MNT/nosymlink/target' to `SCRATCH_MNT/nosymlink/source': Operation not permitted
---
> ln: creating symbolic link `SCRATCH_MNT/nosymlink/target' to `SCRATCH_MNT/nosymlink/source' to `SCRATCH_MNT/nosymlink/source': Operation not permitted

not sure where the double to comes from but we should catch it

130 and 132 expetect Bytes in various places but get bytes from xfs_io
from CVS
