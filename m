Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9D15C7FF8
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:44:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7AEF5304053
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:44:45 -0700 (PDT)
Received: from mail-lf0-f42.google.com (mail-lf0-f42.google.com
	[209.85.215.42]) by cuda.sgi.com with ESMTP id cjpUPsIKDLKk8RaS
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Oct 2015 08:44:43 -0700 (PDT)
Received: by lffv3 with SMTP id v3so82000480lff.0
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:44:42 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 16 Oct 2015 17:44:42 +0200
Message-ID: <CAHc6FU65zy+rDCWapURLr-cApi7b40OhfB7bQK0iC0r_6Wn_qg@mail.gmail.com>
Subject: xfsprogs-dev: Richacl support
From: Andreas Gruenbacher <agruenba@redhat.com>
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

Hello,

could the richacl feature flag please be added to xfsprogs so that we
won't end up with incompatible file systems?

  https://github.com/andreas-gruenbacher/xfsprogs-dev

Also, should this really be an incompatible feature flag? Mounting a
richacl filesystem on a kernel without richacl support would otherwise
work but it could grant unwanted access to files.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
