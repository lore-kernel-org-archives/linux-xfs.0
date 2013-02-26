Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AD9EA7F91
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 23:47:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8AD648F8035
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 21:47:52 -0800 (PST)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id d1Pv8taSMQu6MVkA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Feb 2013 21:47:51 -0800 (PST)
Message-ID: <512C4C7A.60002@tlinx.org>
Date: Mon, 25 Feb 2013 21:47:38 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: FYI: better workaround for updating 'df' info after 'rm' on
	xfs-vols
References: <512C12B5.3070908@tlinx.org> <20130226045038.GN5551@dastard>
In-Reply-To: <20130226045038.GN5551@dastard>
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


>> Someone suggested cat [1|3] >/proc/sys/vm/drop_caches.
> 
> echo, not cat. It does work every time, whether you see anything
> obvious or not. And if you want to reclaim inodes, then you want
> "echo 2 > ..."
----
	Erk...meant echo... too much draino on the braino
(doesn't 3 include '2'? I thought it was a bit mask?)



> freeze/thaw should do what you want without affecting anything
> running on the fs at all.
---
	Thanks... will have to remember / script that ..
Have seen the space not drop for hours!....(literally)..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
