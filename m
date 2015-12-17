Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CC70229DF9
	for <xfs@oss.sgi.com>; Wed, 16 Dec 2015 20:09:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BCD8F304062
	for <xfs@oss.sgi.com>; Wed, 16 Dec 2015 18:09:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id d2dAgUPwFq0kv2SB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Dec 2015 18:09:26 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 0D75B3407F4
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 02:09:26 +0000 (UTC)
Date: Thu, 17 Dec 2015 11:09:24 +0900 (JST)
Message-Id: <20151217.110924.1601408601476764974.yamato@redhat.com>
Subject: Re: [PATCH v2] xfs: send warning of project quota to userspace via
	netlink
From: Masatake YAMATO <yamato@redhat.com>
In-Reply-To: <20151126134933.GA39911@bfoster.bfoster>
References: <20151125185419.GA18719@bfoster.bfoster>
	<1448504560-25151-1-git-send-email-yamato@redhat.com>
	<20151126134933.GA39911@bfoster.bfoster>
Mime-Version: 1.0
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
Cc: bfoster@redhat.com

On Thu, 26 Nov 2015 08:49:33 -0500, Brian Foster <bfoster@redhat.com> wrote:
> On Thu, Nov 26, 2015 at 11:22:39AM +0900, Masatake YAMATO wrote:
>> Linux's quota subsystem has an ability to handle
>> project quota. This commit just utilizes the ability
>> from xfs side.
>> 
> ...
>> Changes in v2:
>> 
>> 	a couple aesthetic things suggested by Brian Foster <bfoster@redhat.com>.
>> 	* rename local vairable for aligning the parameter names,
>> 	* move a short line to the end of its previous line.
>> 
>> Signed-off-by: Masatake YAMATO <yamato@redhat.com>
>> ---
> 
> Thanks for all of the test information. Now you have a really long
> commit log description rather than a short one. ;) Maybe Dave can
> truncate it. Regardless, looks fine to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Any progress?

The patch for userland is merged today:
https://sourceforge.net/p/linuxquota/patches/43/

Masatake YAMATO

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
