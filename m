Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 209D67F50
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 18:06:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E31FC304039
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 16:06:28 -0700 (PDT)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
	[209.85.212.171]) by cuda.sgi.com with ESMTP id
	OI1E8McOkSiBkbRc (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 May 2015 16:06:26 -0700 (PDT)
Received: by wizk4 with SMTP id k4so127856263wiz.1
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 16:06:24 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 May 2015 16:06:24 -0700
Message-ID: <CABppvi4FZKTsu22uk6nOSaShJOUyWg7cO6h-i4YekF4MLKH8RQ@mail.gmail.com>
Subject: XFS crashes on VMs
From: Shrinand Javadekar <shrinand@maginatics.com>
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

Hi,

I am running Openstack Swift in a VM with XFS as the underlying
filesystem. This is generating a metadata heavy workload on XFS.
Essentially, it is creating a new directory and a new file (256KB) in
that directory. This file has extended attributes of size 243 bytes.

I am seeing the following two crashes of the machine:

http://pastie.org/pastes/10210974/text?key=xdmfvaocvawnyfmkb06zg

AND

http://pastie.org/pastes/10210975/text?key=rkiljsdaucrk7frprzgqq

I have only seen these when running in a VM. We have run several tests
on physical server but have never seen these problems.

Are there any known issues with XFS running on VMs?

Thanks in advance.
-Shri

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
