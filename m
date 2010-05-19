Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JBVBT1125389 for <xfs@oss.sgi.com>; Wed, 19 May 2010 06:31:12 -0500
Received: from mx01.bfk.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10C28359A51
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 04:33:29 -0700 (PDT)
Received: from mx01.bfk.de (mx01.bfk.de [193.227.124.2]) by cuda.sgi.com with
	ESMTP id CTyIOlhjnq5gttgn for <xfs@oss.sgi.com>;
	Wed, 19 May 2010 04:33:29 -0700 (PDT)
Received: from mx00.int.bfk.de ([10.119.110.2])
	by mx01.bfk.de with esmtps (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	id 1OEhWe-0003hk-GR
	for xfs@oss.sgi.com; Wed, 19 May 2010 11:33:24 +0000
Received: by bfk.de with local id 1OEhWh-0001SN-C7
	for xfs@oss.sgi.com; Wed, 19 May 2010 11:33:27 +0000
Subject: XFS on 2.6.26: reading the first 4K of a large file takes ages
From: Florian Weimer <fweimer@bfk.de>
Date: Wed, 19 May 2010 11:33:27 +0000
Message-ID: <8239xojfco.fsf@mid.bfk.de>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We've got a couple of rather large files, and with a cold cache,
reading the first 4K bytes of the file (e.g., just running
"head --bytes 4096" on it) takes ages, up to several minutes,
sometimes triggering the hang check timer.

I wonder if XFS reads the whole extent information into RAM when the
file is opened.  Is this the case, at least on 2.6.26?  Has this
changed in later versions, perhaps?

The files in question are heavily fragmented (they have been created
with holes first, and the holes have been filled in subsequently).
I'll try to run xfs_fsr on those files, but it's going to be
tough. 8-/

-- =

Florian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstra=DFe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
