Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 00:29:36 -0700 (PDT)
Received: from molten.melbourne.sgi.com (molten.melbourne.sgi.com [134.14.54.33])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5I7TOML021975
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 00:29:25 -0700
Date: Wed, 18 Jun 2008 17:32:55 +1000
Subject: TAKE 956281 - Fix XFSQA test 144
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080618073255.D5F4A53426@molten.melbourne.sgi.com>
From: donaldd@molten.melbourne.sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Fix XFSQA test 144

Two really dumb bugs:

 - "foo & 0x3FFFFFFFFFFFF" doesn't cap at 1TB, but rather at more than
   two magnitudes larger than that.  That gets us EFBIG with typical
   32bit XFS setups.
 - the command array can easily overflow and thus let the test fail


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Wed Jun 18 17:23:46 AEST 2008
Workarea:  molten.melbourne.sgi.com:/home/donaldd/isms/xfs-cmds
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31327a
xfstests/dmapi/src/suite2/src/test_fileattr.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/dmapi/src/suite2/src/test_fileattr.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- Fix XFSQA test 144
