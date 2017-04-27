Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46234 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031470AbdD0PuE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Apr 2017 11:50:04 -0400
Subject: Re: [PATCH] xfs: Allow user to kill fstrim process
References: <1493282368-32422-1-git-send-email-lczerner@redhat.com>
 <c9a4476c-51d7-b945-4f03-7e5485f3bcb4@sandeen.net>
 <20170427153841.GD23371@birch.djwong.org>
 <6e38c12b-6af9-1613-87dd-0c35df976338@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d9463c18-025e-0b7d-502f-3da43e822938@sandeen.net>
Date: Thu, 27 Apr 2017 10:50:02 -0500
MIME-Version: 1.0
In-Reply-To: <6e38c12b-6af9-1613-87dd-0c35df976338@sandeen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Lukas Czerner <lczerner@redhat.com>, linux-xfs@vger.kernel.org

On 4/27/17 10:46 AM, Eric Sandeen wrote:
> On 4/27/17 10:38 AM, Darrick J. Wong wrote:
>> On Thu, Apr 27, 2017 at 09:34:04AM -0500, Eric Sandeen wrote:
>>> On 4/27/17 3:39 AM, Lukas Czerner wrote:
>>>> fstrim can take really long time on big, slow device or on file system
>>>> with a lots of allocation groups. Currently there is no way for the user
>>>> to cancell the operation. This patch makes it possible for the user to
>>>> kill fstrim pocess by adding the check for fatal_signal_pending() in
>>>> xfs_trim_extents().
>>>
>>> With this patch, it seems that if it is killed, then nothing is copied
>>> back to the user about the number of blocks trimmed before the kill.
>>>
>>> Is that intentional?
>>>
>>> I think it could be done in a way that the progress until the kill
>>> does get reported, and that might be more useful?
>>
>> AFAICT ext4 doesn't report anything if somoene ERESTARTSYS's it...
> 
> Well we aren't ext4, are we?  ;)
> 
> actually, it seems that it may report "count" as ERESTARTSYS in:
> 
>         ext4_debug("trimmed %d blocks in the group %d\n",
>                 count, group);
> 
> But yeah, although it does update the &range values, they don't
> get copied out on any error.
> 
> Anyway, ok, ext4 doesn't.  Is there a reason that we shouldn't?

Ok I am probably misunderstanding how things work, maybe it's
not actually possible (he says after a little experimentation.)
Feel free to ignore me on this one.  :)

-Eric
 
