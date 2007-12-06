Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Dec 2007 19:13:06 -0800 (PST)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lB63CxtL028406
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2007 19:13:01 -0800
Received: from mtv-amer002e--3.americas.sgi.com (unknown [192.26.64.114])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 03A428F8065
	for <xfs@oss.sgi.com>; Wed,  5 Dec 2007 19:13:07 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Subject: RE: [Patch] xfs_lowbit64 broken on ia32
Date: Wed, 5 Dec 2007 18:15:41 -0800
Message-ID: <D59801BCA402F5418C040937230AF7E0755B27@mtv-amer002e--3.americas.sgi.com>
In-Reply-To: <47573C8A.1060902@sgi.com>
From: "Alex Elder" <aelder@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Lachlan Mcllroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Timothy Shimmin wrote:
> I've never heard of that either.
> (Then again, I didn't know until recently that they changed C
>   to allow "flexible array members" in C99
>   http://tigcc.ticalc.org/doc/gnuexts.html#SEC75)

Yeah there's lots of fancy new stuff in C99.

Like variable length arrays, language-supported
complex (sqrt(-1)) data types, C++ style
initializations (mid-functions).  And you can
declare your loop index variable inside a for
loop's parentheses (its scope is defined only
for the loop).

I'm not ready to use most of that; it has less
value than some of the "old" extensions like
(void *) and 0-length arrays.  But some things
are defined very precisely and that's good.

					-Alex
