Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35686 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966304AbeE2VqV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 May 2018 17:46:21 -0400
Subject: Re: [PATCH 7/7] libxfs: remove crc32 functions
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
 <152728634020.22515.16684194597988861920.stgit@magnolia>
 <23568dc9-61d2-0eb9-819a-1386f7276408@oracle.com>
 <20180528141136.3anksl5xaftofkkk@odin.usersys.redhat.com>
 <20180529145650.GB30110@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0eb16d84-1818-1716-8bee-1d95f8b365ad@sandeen.net>
Date: Tue, 29 May 2018 16:46:19 -0500
MIME-Version: 1.0
In-Reply-To: <20180529145650.GB30110@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Allison Henderson <allison.henderson@oracle.com>, sandeen@redhat.com, linux-xfs@vger.kernel.org



On 5/29/18 9:56 AM, Darrick J. Wong wrote:
> On Mon, May 28, 2018 at 04:11:36PM +0200, Carlos Maiolino wrote:
>> On Sun, May 27, 2018 at 08:53:04PM -0700, Allison Henderson wrote:
>>> Seems like it would be ok.  But if these functions are not really used,
>>> is there a reason as to why we are just commenting them out instead of
>>> removing them entirely?  Thx!
>>
>> I've the same question, I'd say you expect to keep them there for historical
>> reasons, but I think at least a comment in the patch description would be fine,
>> but either if you keep the commented code, or remove it completely:
> 
> It's hard to say -- xfsprogs ported the slice-by-8 code from the kernel,
> then #if'd out some of the irrelevant bits.  If we ever need to resync
> w/ the kernel it'd be much easier to do so if the file is mostly intact
> save for some preprocessor gunk to debloat the object files.
> 
> OTOH this file is ugly.  Let's see if the maintainer accepts this or
> yells 'rewrite!' :)

oh I had missed this.

.... 'rewrite!'

Let's just remove the unused stuff.  We don't need it for libxfs-sync-ability
or libxfs-diff-happiness, so I'd say just nuke it.  git history is there for
a reason.

V2 or another patch for later is fine though.

-Eric
