Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52382 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751718AbdIUNyE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Sep 2017 09:54:04 -0400
Subject: Re: [PATCH 4/7] xfs: Implement fallocate query support mode
References: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
 <1505749947-26360-5-git-send-email-lczerner@redhat.com>
 <20170918204838.GW6540@magnolia>
 <7B6B7C4C-7FEB-401F-B4EE-6E11E95FB246@dilger.ca>
 <20170919145520.c4y4w32lmsnqhhxp@thunk.org>
 <20170919155528.GA8907@infradead.org>
 <563513ad-afb5-4c76-9f38-4b2e79e7af8a@redhat.com>
 <20170919203719.GD731@infradead.org>
 <20170919231716.tmdiz3vnzretwrks@thunk.org>
From: Florian Weimer <fweimer@redhat.com>
Message-ID: <9b2ffed5-6bef-977e-14d5-13e078c4734f@redhat.com>
Date: Thu, 21 Sep 2017 15:54:01 +0200
MIME-Version: 1.0
In-Reply-To: <20170919231716.tmdiz3vnzretwrks@thunk.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>
Cc: Andreas Dilger <adilger@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, Lukas Czerner <lczerner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On 09/20/2017 01:17 AM, Theodore Ts'o wrote:
> There might be some tricky bits will be if glibc feels it needs to
> override the values returned by the kernel (if it believes it may
> impose some limitations due to its implementation).  Also, not all
> file systems will implement some or all pathconf parameters initially
> (or perhaps ever).  So should the VFS be responsible for returning
> some intelligent defaults, or glibc?

I'd prefer if we could export pathconfat directly on the glibc side, 
without any emulation, and have the application deal with ENOSYS.

We would use it to implement parts of pathconf/fpathconf if available, 
but I don't think we should copy the existing emulation for pathconfat 
because every time we add such emulation, it comes back to haunt us.

Thanks,
Florian
