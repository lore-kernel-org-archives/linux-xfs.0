Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42776 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbeJHWLi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Oct 2018 18:11:38 -0400
Subject: Re: [PATCH 08/15] xfsprogs: avoid redefinition of NBBY
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
 <1538712196-13625-9-git-send-email-sandeen@sandeen.net>
 <20181006101248.GH28114@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <027ab8c7-1042-a795-5cfc-3df0d92f2475@sandeen.net>
Date: Mon, 8 Oct 2018 09:59:29 -0500
MIME-Version: 1.0
In-Reply-To: <20181006101248.GH28114@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On 10/6/18 5:12 AM, Christoph Hellwig wrote:
> On Thu, Oct 04, 2018 at 11:03:09PM -0500, Eric Sandeen wrote:
>> From: Eric Sandeen <sandeen@redhat.com>
>>
>> sys/param.h (re)defines NBBY so just include it first.
> 
> Include it before what?  We probably should also remove the other
> definition..

We have an internal definition, maybe it was for other platforms?
Not sure.  Maybe we can just remove our local definition - it's been
there forever, not quite sure when things changed.

-Eric
