Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36568 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754945AbcIJSPJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Sep 2016 14:15:09 -0400
MIME-Version: 1.0
In-Reply-To: <20160910074034.GA18332@infradead.org>
References: <1473348594-31425-1-git-send-email-amir73il@gmail.com>
 <20160908202511.GV30056@dastard> <CAOQ4uxigN71Evm_mhFzijtDaXAvKQqstryvNoBEL7=Uwgt5xFg@mail.gmail.com>
 <20160909075439.GE30056@dastard> <CAOQ4uxguEpSeq5A==gGCcVocY=5xSO+cEcUNr2GDYAbjvx4+Dw@mail.gmail.com>
 <20160909235221.GH30056@dastard> <20160910074034.GA18332@infradead.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 10 Sep 2016 21:15:06 +0300
Message-ID: <CAOQ4uxj=XzcPe1HdynToitEHo4SEtaU3pV86yFWj3y=MURY-7g@mail.gmail.com>
Subject: Re: [PATCH] ovl: use copy_file_range for copy up if possible
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sat, Sep 10, 2016 at 10:40 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, Sep 10, 2016 at 09:52:21AM +1000, Dave Chinner wrote:
>> > vfs_copy_file_range() implementation because ovl_copy_up_data()
>> > splices in small chunks allowing the user to kill the copying process.
>> > This makes sense because the poor process only called open(),
>> > so the app writer may not have been expecting a stall of copying
>> > a large file...
>>
>> So call vfs_copy_file_range() iteratively, just like is being done
>> right now for do_splice_direct() to limit latency on kill.
>
> I wish vfs_copy_file_range would do useful chinking itself.
>

I guess that is more changes then I set out to do here, but
if there is consensus about this idea I don't mind drafting the patch.

> But either way it might be a good idea to call vfs_clone_file_range
> first, because that gives your a very efficient copy without the need
> to copy anything if supported.

Definitely. I'll do that.
Thanks.
