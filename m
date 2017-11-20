Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50192 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751863AbdKTSKi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 Nov 2017 13:10:38 -0500
Subject: Re: [PATCH 2/2] xfs_io: stat: treat statfs.f_flags as optional
From: Eric Sandeen <sandeen@sandeen.net>
References: <20171117195457.16218-1-jeffm@suse.com>
 <20171117195457.16218-2-jeffm@suse.com>
 <eb6a3a1c-3d0b-e266-b2af-cde661b65b7a@sandeen.net>
Message-ID: <b6e0865f-5528-c7c9-9663-1a14e660c243@sandeen.net>
Date: Mon, 20 Nov 2017 12:10:37 -0600
MIME-Version: 1.0
In-Reply-To: <eb6a3a1c-3d0b-e266-b2af-cde661b65b7a@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: jeffm@suse.com, linux-xfs@vger.kernel.org



On 11/20/17 11:54 AM, Eric Sandeen wrote:
> 
> 
> On 11/17/17 1:54 PM, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> Kernels prior to 2.6.36 didn't contain statfs.f_flags.  Distros with
>> initial releases with kernels prior to this may not have updated
>> headers with this member.
> 
> You all are brave ;)
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Oops, but not tested-by!  This also needs:

diff --git a/io/Makefile b/io/Makefile
index 050d6bd..6725936 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -110,6 +110,10 @@ ifeq ($(PKG_PLATFORM),linux)
 CFILES += fsmap.c
 endif
 
+ifeq ($(HAVE_STATFS_FLAGS),yes)
+LCFLAGS += -DHAVE_STATFS_FLAGS
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)


but I can add it on the way in.

-Eric
