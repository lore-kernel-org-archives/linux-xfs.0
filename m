Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44244 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751814AbdHaPzd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Aug 2017 11:55:33 -0400
Subject: Re: [PATCH] xfs: remove experimental tag for reflinks
References: <20170830145400.3681-1-hch@lst.de>
 <20170831064033.GF3775@magnolia> <20170831124321.GA21939@bfoster.bfoster>
 <20170831133019.GA5468@lst.de> <20170831153148.GJ3775@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <4b7dda9e-f470-65b6-08d0-e862dc967cd4@redhat.com>
Date: Thu, 31 Aug 2017 10:55:31 -0500
MIME-Version: 1.0
In-Reply-To: <20170831153148.GJ3775@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On 8/31/17 10:31 AM, Darrick J. Wong wrote:
> On Thu, Aug 31, 2017 at 03:30:19PM +0200, Christoph Hellwig wrote:
>> On Thu, Aug 31, 2017 at 08:43:21AM -0400, Brian Foster wrote:
>>> FWIW, I don't really have a strong opinion. To me, removing experimental
>>> means we feel the code has stabilized long enough in principle, there
>>> are no significant problems (i.e., corruption/crash vectors) that we are
>>> aware of and the feature is complete (full userspace tool support, etc).
>>> The in-core extent list thing seems like more of a general problem to me
>>
>> Agreed so far.
> 
> <nod> Dave?  Eric?  Any perspective you'd like to offer? :)

This is a bit of a naiive question, but how many applications are out
there that can be used with reflink right now?  This would obviously
delay things a bit, but I had considered writing something up for
LWN or Fedora Planet or $WHATEVER describing these new xfs features,
how they can be used, and encourage some early-adopter testing.  Try
to get some buzz going and some real-world use.

It's always a catch 22; nobody uses it until it's marked stable,
but we never know if it's really stable until people outside the
development community use it.  ;)

As for the allocation issues w/ the in core extent list, yeah, that
worries me.

-Eric
