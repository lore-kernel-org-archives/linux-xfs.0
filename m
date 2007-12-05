Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Dec 2007 05:20:56 -0800 (PST)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lB5DKoKN021684
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2007 05:20:51 -0800
Received: from mtv-amer002e--3.americas.sgi.com (unknown [192.26.64.114])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 006A68F805F
	for <xfs@oss.sgi.com>; Wed,  5 Dec 2007 05:01:27 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Subject: RE: [Patch] xfs_lowbit64 broken on ia32
Date: Wed, 5 Dec 2007 04:14:02 -0800
Message-ID: <D59801BCA402F5418C040937230AF7E0755AF5@mtv-amer002e--3.americas.sgi.com>
In-Reply-To: <20071205032128.GB115527101@sgi.com>
From: "Alex Elder" <aelder@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Lachlan Mcllroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

David Chinner wrote:
. . .
> > >Index: 2.6.x-xfs-new/fs/xfs/xfs_bit.h
> > >===================================================================
> > >--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bit.h	2007-11-02 
> > >13:44:45.000000000 +1100
> > >+++ 2.6.x-xfs-new/fs/xfs/xfs_bit.h	2007-12-03 
> 14:43:33.169851481 +1100
> > >@@ -68,8 +68,8 @@ static inline int xfs_lowbit32(__uint32_
> > > /* Get low bit set out of 64-bit argument, -1 if none set */
> > > static inline int xfs_lowbit64(__uint64_t v)
> > > {
> > >-	unsigned long	t = v;
> > >-	return (v) ? find_first_bit(&t, 64) : -1;
> > >+	unsigned long long	t = v;
> > Why create a local copy?  Why not just pass v into find_first_bit()?
> 
> Because I thought that taking the address of a function parameter
> was a big no-no because the result is undefined (i.e. platform and
> compiler dependent)?

I've never heard of this, and it's incorrect--at least with respect
to standard C.  (But that's not to say in practice some compiler
does it wrong.)  Unless it's a real (details known) problem you
shouldn't try to work around it.

					-Alex
