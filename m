Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Feb 2008 03:17:34 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1CBGsme003056
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2008 03:16:57 -0800
Received: from out4.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A30FD5C71A9
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2008 03:17:16 -0800 (PST)
Received: from out4.smtp.messagingengine.com (out4.smtp.messagingengine.com [66.111.4.28]) by cuda.sgi.com with ESMTP id 3x3TQ2jeIhPkrKAo for <xfs@oss.sgi.com>; Tue, 12 Feb 2008 03:17:16 -0800 (PST)
Message-Id: <1202815035.5821.1236404891@webmail.messagingengine.com>
From: "Felix E. Klee" <felix.klee@inka.de>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
References: <1202769551.16458.1236311973@webmail.messagingengine.com>
   <47B0E26D.7070807@sgi.com>
Subject: Re: Restoring damaged incremental XFS dump?
In-Reply-To: <47B0E26D.7070807@sgi.com>
Date: Tue, 12 Feb 2008 12:17:15 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, 12 Feb 2008 11:03:57 +1100, "Timothy Shimmin"
<tes@sgi.com> said:
> I'm not sure what you mean by "true snapshots". I wouldn't really
> call it snapshots as in what you could get if you froze the
> filesystem etc..

Oh, it does not freeze the filesystem - what a pity.  I recall someone
telling me that it does.  Seems like that was bad information or my
memory is failing on me.

> > So, what happens when the level 0 dump created with xfsdump becomes
> > damaged.  Will I still be able to recover some files?  What about
> > files from >0 dumps?
>
> Yes you will still be able to restore stuff. However, it is in its own
> format so only xfsrestore will be able to do your restoring. Dumps are
> separated into what it calls media files which are meant to be self
> containing. So damage to 1 theoretically shouldn't prevent restoring
> from another media file. Multiple media files are normally only used
> for tape (only 1 used for a dump to a file). And an incremental dump
> should also be able to be restored in isolation and there are some QA
> tests (in xfs-cmds/xfstests) that test this.

Thanks!

Felix

-- 
Dipl.-Phys. Felix E. Klee
Naunynstr. 2, 76530 Baden-Baden, Germany
Tel.: +49 7221 396961, Fax: +49 7221 396960, Mobile: +49 174 1386060
http://www.linkedin.com/in/feklee
