Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47552 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbeJHXDA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Oct 2018 19:03:00 -0400
Subject: Re: [PATCH 15/15] libfrog: change project entity variable scope
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
 <1538712196-13625-16-git-send-email-sandeen@sandeen.net>
 <20181006101855.GO28114@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1dc747cd-d4a4-8a6e-c829-89027fcadd73@sandeen.net>
Date: Mon, 8 Oct 2018 10:50:37 -0500
MIME-Version: 1.0
In-Reply-To: <20181006101855.GO28114@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org



On 10/6/18 5:18 AM, Christoph Hellwig wrote:
> While the scope change is a good start the code is stull horrible.
> 
> I'd be much happier to kill these static variables entirely.  The
> buffers can just be on stack, and getprent should just get a
> fs_project_t to fill out passed by reference.  Same for
> getprpathent.
> 

I had assumed that the goal was to behave just like getpwent, which
is a void function and does not require a struct passwd to be
passed in (for example).  The symmetry of use made sense to me.

-Eric
