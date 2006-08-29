Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Aug 2006 01:50:32 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7T8oODW011425
	for <xfs@oss.sgi.com>; Tue, 29 Aug 2006 01:50:24 -0700
Message-ID: <44F3F056.6040503@gmx.net>
Date: Tue, 29 Aug 2006 09:44:22 +0200
From: Klaus Strebel <klaus.strebel@gmx.net>
MIME-Version: 1.0
Subject: Re: accidently deleted files from directory
References: <44f3c278.059fc255.3075.3597@mx.gmail.com>
In-Reply-To: <44f3c278.059fc255.3075.3597@mx.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: gert wohlgemuth <wohlgemuth@ucdavis.edu>
Cc: xfs@oss.sgi.com

gert wohlgemuth schrieb:
> Thx,
> 
> I thought so that the data are gone and it's to much to glue it, cause all
> binary data.
> 
> So time to step back to ext2, here at least I can restore the data in the
> worst case.
Just out of curiosity, could you write an info to the list, how long
your 'some-terrabyte-ext2'-filesystem needs to mount and - every 20th-or
-so mount, how long a fsck is running on when if it's well filled ;-).
I once tried to restore deleted files on a webserver using ext2, i can
tell you, thats no fun. Many programs make copies of the files they are
working on, write there changes, delete the old file and rename the new.
So expect to get lots and lots of versions of files where you have to
decide which is the latest you want to use, and sometimes, its not the
latest by accesstime ...

> 
> ...not that it ever happens again...
>> after I did a cat /dev/sda1 | less I could see that some data are still
>> exist and are not overwritten. So I think "all" what I have todo is some
> how
>> get the journal back.
> 
> that won't suffice, the metadata showing where all the files are is
> likely gone
> 
Well, getting a consistent state ( in this case all metadata removed )
is why we use filesystems like XFS.

-- 
Mit freundlichen Grüssen / best regards

Klaus Strebel, Dipl.-Inform. (FH), mailto:klaus.strebel@gmx.net

/"\
\ /     ASCII RIBBON CAMPAIGN
 X        AGAINST HTML MAIL
/ \
