Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 19:04:05 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4K2432k004072
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 19:04:03 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D9BBA17001B6
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 19:04:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id cQlh66bd0T4MXJGH for <xfs@oss.sgi.com>; Mon, 19 May 2008 19:04:52 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 49230AC08CA
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 21:04:51 -0500 (CDT)
Message-ID: <483231C2.9010504@sandeen.net>
Date: Mon, 19 May 2008 21:04:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] de-duplicate calls to xfs_attr_trace_enter
References: <480024CC.8040407@sandeen.net>
In-Reply-To: <480024CC.8040407@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Every call to xfs_attr_trace_enter() shares the exact 
> same 16 args in the middle... just send in the context
> pointer and let the next level down split it into the
> ktrace.

Ping?  worth doing?

Thanks,

-Eric
