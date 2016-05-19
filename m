Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 095987CA0
	for <xfs@oss.sgi.com>; Thu, 19 May 2016 10:09:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B8F1030404E
	for <xfs@oss.sgi.com>; Thu, 19 May 2016 08:09:08 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [206.12.19.147]) by
	cuda.sgi.com with ESMTP id xHmFxGjddaXhMROs (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 19 May 2016 08:09:06 -0700 (PDT)
Subject: Bug#822369: fixed in qemu 1:2.6+dfsg-1
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.822369.B822369.146367044910738@bugs.debian.org>
References: <573DCFAA.8000500@physik.fu-berlin.de>
	<573DD225.5040502@msgid.tls.msk.ru>
	<573DD3CC.6040608@physik.fu-berlin.de>
From: Michael Tokarev <mjt@tls.msk.ru>
Message-ID: <573DD6AF.5020608@msgid.tls.msk.ru>
Date: Thu, 19 May 2016 18:07:27 +0300
MIME-Version: 1.0
In-Reply-To: <573DD3CC.6040608@physik.fu-berlin.de>
Reply-To: Michael Tokarev <mjt@tls.msk.ru>, 822369@bugs.debian.org
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
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: 822369@bugs.debian.org

Control: affects -1 - qemu
Control:

19.05.2016 17:55, John Paul Adrian Glaubitz wrote:
> On 05/19/2016 04:48 PM, Michael Tokarev wrote:
>> Actually it is more interesting.  This bug is listed in qemu bug list,
>> see https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=qemu , AND in
>> xfsprogs bug list, see
>> https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=xfsprogs
> 
> If you look closer that the package is actually "xfsprogs" in both
> cases. The bug just shows up in the bug tracker of the qemu package
> because it is affected by the bug.

Ok, that makes sense.  Indeed, while it is listed for qemu, it
is marked belonging to xfsprogs.  I've never saw this before,
and thought it is qemu bug not xfsprogs bug.

> If that is no longer the case, we should remove the association
> here, i.e. removing "affects src:qemu", but not close the actual
> bug because the package which is the actual origin of the bug has
> not been fixed yet.
> 
>> I closed it thinking it is in qemu.  But I closed it wrongly anyway,
>> and that's where I should've been more careful.  In qemu there was
>> a workaround proposed for this issue, but it hasn't been applied,
>> and I thought it has been.  So it has already been reopened meanwhile.
> 
> Apparently the workaround has been applied in qemu, otherwise qemu
> wouldn't build. I will verify that. I have to build a patched version
> of qemu for sparc64 manually anyway.

And now this is lack of closer look on my side again.  Yes, the
workaround has actually been applied, and I hasn't reopened this
bug yesterday.. Oh well :))  I was thinking about different bug.

Thank you for your patience and explanations!

/mjt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
