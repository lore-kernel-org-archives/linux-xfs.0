Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:35924 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751780AbdIGHKd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2017 03:10:33 -0400
MIME-Version: 1.0
In-Reply-To: <20170905113128.GG8034@eguan.usersys.redhat.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
 <1504104706-11965-8-git-send-email-amir73il@gmail.com> <20170905104641.GA8034@eguan.usersys.redhat.com>
 <CAOQ4uxi1mu5QXt3PJuk27WJvm+vS63ct+VQsDJvxvaLiEGzrAA@mail.gmail.com> <20170905113128.GG8034@eguan.usersys.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 7 Sep 2017 10:10:32 +0300
Message-ID: <CAOQ4uxjG50pRPnLQLT+3b+BVePvfc9QHUaVukRugQzpwptrjjw@mail.gmail.com>
Subject: Re: [PATCH v2 07/14] fsx: add optional logid prefix to log messages
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Sep 5, 2017 at 2:31 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Tue, Sep 05, 2017 at 02:24:20PM +0300, Amir Goldstein wrote:
>> On Tue, Sep 5, 2017 at 1:46 PM, Eryu Guan <eguan@redhat.com> wrote:
>> > On Wed, Aug 30, 2017 at 05:51:39PM +0300, Amir Goldstein wrote:
>> >> When writing the intermixed output of several fsx processes
>> >> to a single log file, it is usefull to prefix logs with a log id.
>> >> Use fsx -j <logid> to define the log messages prefix.
>> >
>> > Would it be better to allow any string as prefix, not limit to id
>> > number?
>> >
>>
>> Maybe, but I didn't see an immediate need for that beyond
>> the concurrent test runs, for with numeric id is sufficient.
>
> I agreed, I don't have strong preference on this.
>

Nah, you were right the first time. Using numeric id was just me
being lazy and then I had a bug where -j 0 (not surprising) does
not prefix logs with 0:
I'll fix this and re-post the fsx patches.

Amir.
