Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751306AbdISTRb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Sep 2017 15:17:31 -0400
Subject: Re: [PATCH 4/7] xfs: Implement fallocate query support mode
References: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
 <1505749947-26360-5-git-send-email-lczerner@redhat.com>
 <20170918204838.GW6540@magnolia>
 <7B6B7C4C-7FEB-401F-B4EE-6E11E95FB246@dilger.ca>
 <20170919145520.c4y4w32lmsnqhhxp@thunk.org>
 <20170919155528.GA8907@infradead.org>
From: Florian Weimer <fweimer@redhat.com>
Message-ID: <563513ad-afb5-4c76-9f38-4b2e79e7af8a@redhat.com>
Date: Tue, 19 Sep 2017 21:17:28 +0200
MIME-Version: 1.0
In-Reply-To: <20170919155528.GA8907@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, Lukas Czerner <lczerner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On 09/19/2017 05:55 PM, Christoph Hellwig wrote:
> On Tue, Sep 19, 2017 at 10:55:20AM -0400, Theodore Ts'o wrote:
>> Maybe the right answer is we should define a new pathconfat(2) system
>> call which can be used as part of a C library's implementation of
>> pathconf() and fpathconf()?  glibc probably won't use it for years, of
>> course.  But we can at least provide the information via an interface
>> which we can control, and which is capable of returning correct
>> results?
> 
> glibc is very fast at picking up new kernel interface these days
> as long as they aren't too controversial.  Implementing a syscall
> that backs a function they implement should not be in the controversial
> category I think.

We have a significant backlog, but I don't expect opposition to patches 
implementing syscall wrappers which are just slightly generic (and 
pathconfat should really be fine).

Technically, pathconfat might be tricky to maintain if it's expected to 
be a variadic dispatcher function, and the accompanying UAPI header 
isn't very clean.

Thanks,
Florian
