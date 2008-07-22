Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 19:49:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6M2nNhO002931
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 19:49:25 -0700
Message-ID: <48854C38.8050007@sgi.com>
Date: Tue, 22 Jul 2008 12:55:52 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Do not access buffers after dropping reference count
References: <4885430D.7000506@sgi.com> <20080722022404.GH6761@disturbed>
In-Reply-To: <20080722022404.GH6761@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Tue, Jul 22, 2008 at 12:16:45PM +1000, Lachlan McIlroy wrote:
>> We should not access a buffer after dropping it's reference count otherwise
>> we could race with another thread that releases the final reference count
>> and frees the buffer causing us to access potentially unmapped memory.
> 
> Looks OK. The commit message should point out this is a problem
> only for DEBUG kernels, though.

Okay, will do.
