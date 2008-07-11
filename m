Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 22:43:48 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B5hkkE030643
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 22:43:47 -0700
Received: from outhouse.melbourne.sgi.com (outhouse.melbourne.sgi.com [134.14.52.145])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 112628F8066
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 22:44:50 -0700 (PDT)
Received: from lagoh (xaiki@melb-sw-corp-251-1.corp.sgi.com [134.15.251.1])
	by outhouse.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id m6B5ihjm2592843
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 15:44:47 +1000 (AEST)
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH] Give a transaction to xfs_attr_set_int
In-Reply-To: <1215675545-2707-5-git-send-email-xaiki@sgi.com> (Niv Sardi's
	message of "Thu, 10 Jul 2008 17:39:05 +1000")
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com>
	<1215675545-2707-1-git-send-email-xaiki@sgi.com>
	<1215675545-2707-2-git-send-email-xaiki@sgi.com>
	<1215675545-2707-3-git-send-email-xaiki@sgi.com>
	<1215675545-2707-4-git-send-email-xaiki@sgi.com>
	<1215675545-2707-5-git-send-email-xaiki@sgi.com>
Date: Fri, 11 Jul 2008 15:44:39 +1000
Message-ID: <878ww9asag.fsf@cxhome.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Ok, so following are 2 patches that will, export xfs_attr_set_int_trans,
and use it where we would use it in Parent Pointers (and V4ACL to what I
understand).

This exposes the bug that I refered to before, and that I'm not sure I
understand fully.

Cheers,
-- 
Niv Sardi
