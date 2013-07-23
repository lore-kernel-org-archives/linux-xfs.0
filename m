Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4106E7F3F
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 16:29:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BD1F2AC009
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 14:29:52 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id o0cyo78z0AmjTXBQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Jul 2013 14:29:51 -0700 (PDT)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id
	r6NLTjVw089047 for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 14:29:47 -0700
Message-ID: <51EEF5C6.3050904@tlinx.org>
Date: Tue, 23 Jul 2013 14:29:42 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: BUG: ACL's are a security attribute. They belong in the Security
	attrib space, not the Root-attrib space.
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


Currently there are 3 disjoint attribute spaces on files -- user, root and security.

(there is a misprint in the manual that says there is 2, but later, it gives
talks about using no switch giving the User attrib space, -R for Root attrib
space, and -S for the Security attrib space).


Of these, the ACL's are being placed in the root, which might describe
file types, or other OS related info, but not security attributes like ACL's.
They should be in the Security attrib space (otherwise what is the point of a
Security attribute space).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
