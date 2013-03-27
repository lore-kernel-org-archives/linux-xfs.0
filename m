Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8BCD37F50
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 15:32:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 79F0F8F8070
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 13:32:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NyRU1EICbvZBCXCF for
	<xfs@oss.sgi.com>; Wed, 27 Mar 2013 13:32:36 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2RKWa9b031603
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 16:32:36 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-112.phx2.redhat.com
	[10.3.113.112])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r2RKWWAY023465
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 16:32:35 -0400
Date: Wed, 27 Mar 2013 17:32:32 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: xfstests should still make xfs as default?
Message-ID: <20130327203231.GA26739@andromeda.usersys.redhat.com>
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

Hi, working on xfstests after its new directory structures I noticed we should
use now something like:

./check xfs/<test>

to run some tests, IMHO this is not intuitive and I was working on a patch to
make us able to use something just like the old way:

./check <test>

But, since xfstests is becoming more generalist than xfs specific, I wonder if
we should still keep xfs as default.

What you guys think?

I'll work on a patch to keep it as default or at least giving a suggestion on
how to call a specific test in the new way.

Cheers

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
