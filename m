Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 21:25:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4K4OxqP019760
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 21:25:02 -0700
Message-ID: <483252C7.5050108@sgi.com>
Date: Tue, 20 May 2008 14:25:43 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] de-duplicate calls to xfs_attr_trace_enter
References: <480024CC.8040407@sandeen.net> <483231C2.9010504@sandeen.net>
In-Reply-To: <483231C2.9010504@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Eric Sandeen wrote:
>> Every call to xfs_attr_trace_enter() shares the exact 
>> same 16 args in the middle... just send in the context
>> pointer and let the next level down split it into the
>> ktrace.
> 
> Ping?  worth doing?
> 
Yeah, that sounded reasonable as it was pretty messy.
I'll take it...

--Tim
