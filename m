Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 13:32:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2PKWA8E026877
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 13:32:11 -0700
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B17566E8B75
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 13:32:43 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com with ESMTP id DxvXDEro9Fd4h1uh for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 13:32:43 -0700 (PDT)
From: "NeilBrown" <neilb@suse.de>
Date: Wed, 26 Mar 2008 07:32:01 +1100 (EST)
Message-ID: <32953.192.168.1.70.1206477121.squirrel@neil.brown.name>
In-Reply-To: <20080325190943.GF2237@fieldses.org>
References: <47CF157B.1010908@m2000.com>
    <18383.24847.381754.517731@notabene.brown> <47CF62C5.7000908@m2000.com>
    <18384.50909.866848.966192@notabene.brown>
    <9a8748490803121513w285cd45rb6b26a3d842cac1b@mail.gmail.com>
    <20080312221511.GC31632@fieldses.org>
    <9a8748490803121516u36395872i70cc88b0439adc74@mail.gmail.com>
    <18394.1501.991087.80264@notabene.brown> <47DAEFD0.9020407@m2000.com>
    <47E92F8E.7030504@m2000.com> <20080325190943.GF2237@fieldses.org>
Subject: Re: [opensuse] nfs_update_inode: inode X mode changed, Y to Z
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>, xfs@oss.sgi.com
Cc: Adam Schrotenboer <adam@m2000.com>, Jesper Juhl <jesper.juhl@gmail.com>, Trond Myklebust <trond.myklebust@netapp.com>, lkml@vger.kernel.org, linux-nfs@vger.kernel.org, Thomas Daniel <tdaniel@m2000.com>, Frederic Revenu <frevenu@m2000.com>, Jeff Doan <jdoan@m2000.com>

On Wed, March 26, 2008 6:09 am, J. Bruce Fields wrote:
> On Tue, Mar 25, 2008 at 09:59:58AM -0700, Adam Schrotenboer wrote:
>> Adam Schrotenboer wrote:
>>> Neil Brown wrote:
>>>> On Wednesday March 12, jesper.juhl@gmail.com wrote:
>>>>> On 12/03/2008, J. Bruce Fields <bfields@fieldses.org> wrote:
>>>>>> What was the exported filesystem?
>>>>> XFS
>>>>
>>>> It's a bit of a long shot, but could you try mounting the XFS file
>>>> system with
>>>>    -o ikeep
>>>>
>>>> and see if it makes a difference.
>>>>
>>>> When you have "ikeep", I can find the code that increments the
>>>> generation number between different uses of the one inode number.
>>>>
>>>> When you have "noikeep" (which I think is the default) it doesn't keep
>>>> the inode of disk when deleted and so (presumably) needs generate a
>>>> random generation number for each use.  But I cannot find the code
>>>> that does that.  I'm probably not looking in the right place, but I
>>>> don't think it can hurt to try "-o ikeep".
>>>>
>>>> NeilBrown
>>>>
>>> Ok, I've unmounted and remounted with that option enabled
>>> (/proc/mounts confirms it's enabled). We'll see what happens.
>>
>>    Well, it's been almost 2 weeks (11 days anyhow) and I am not seeing
>> the nfs_update_inode message in the syslogs of any of our compute
>> servers. I need to talk to the various people who work with them to
>> verify, but it looks like this problem has been resolved.
>
> That's a workaround, at least, but it's unfortunate if a special mount
> option is required to get correct behavior for nfs exports.  Is there
> anything we can do?
>

I suggest taking it up with the XFS developers...

Dear XFS developers.
 Adam (and Jesper, though that was some time ago) was having problems
with an XFS filesystem that was exported via NFS.  The client would
occasionally report the message given in the subject line.
Examining the NFS code suggested that the most likely explanation
was that the generation number used in the file handle was the same
every time that the inode number was re-used.

Examining the XFS code suggested that when the 'ikeep' mount option was
used, the generation number be explicitly incremented for each
re-use, while without 'ikeep', no evidence of setting the generation
number could be found.  Maybe it defaults to zero.

Experimental evidence suggests that setting 'ikeep' removes the symptom.

Question:  Is is possible that without 'ikeep', XFS does not even try
to provide unique generation numbers?  If this is the case, could it
please be fixed.  If it is not the case, please help me find the code
responsible.

Thanks,
NeilBrown
