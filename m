Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 24EBB7F7E
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 02:18:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B4453AC002
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 00:18:54 -0700 (PDT)
Received: from mail-we0-f172.google.com (mail-we0-f172.google.com
	[74.125.82.172]) by cuda.sgi.com with ESMTP id DRA9t9bKFtGDVGo9
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 28 Jul 2013 00:18:53 -0700 (PDT)
Received: by mail-we0-f172.google.com with SMTP id t61so3096813wes.3
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 00:18:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <31450470.2412.1374978094689.JavaMail.root@benjamin.baylink.com>
References: <52C3E9E6-61DD-4537-9A64-C8CBFC86F6E3@gmail.com>
	<31450470.2412.1374978094689.JavaMail.root@benjamin.baylink.com>
Date: Sun, 28 Jul 2013 09:18:52 +0200
Message-ID: <CAAxjCEwwmu_4Xxc8xyPw5Jk2LLTag93698M_EQZb7TxnsVSqXw@mail.gmail.com>
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
From: Stefan Ring <stefanrin@gmail.com>
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
To: Jay Ashworth <jra@baylink.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

> "You have to talk to whomever builds the kernel packages for the distro
> you're working on; they should be able to tell you which XFS {version|
> release|checkout} is built into that particular kernel RPM."

For what it's worth, you can try to pry this info out of Oracle's
RedPatch <https://oss.oracle.com/projects/RedPatch/>, which actually
doesn't look all that active anymore recently, but given that it's
Oracle, one cannot seriously be surprised about anything.

The thing is, that RHEL XFS and mainline XFS seem to have drifted
apart a good deal, and as result, for an outsider, it is very
difficult to correlate patches between the two branches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
