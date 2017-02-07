Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35584 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751094AbdBGJEn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Feb 2017 04:04:43 -0500
Date: Tue, 7 Feb 2017 10:04:39 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: I had an occasion that XFS is not able to fully detect or
 recover from severe file system corruption
Message-ID: <20170207090439.nlcbwknpyrsuacl7@eorzea.usersys.redhat.com>
References: <CAEtPA0BOdAHjtoRrrX3Ha6iHe4VXOUxNe7KPaEdJM=8yYstQMA@mail.gmail.com>
 <68f4911f-a55a-c21c-1eb0-91c81187c774@sandeen.net>
 <CAEtPA0AbqHKn1-RZiN1g8xHJ8wmZrjXiL40BWVRzn1xzZ2x0EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEtPA0AbqHKn1-RZiN1g8xHJ8wmZrjXiL40BWVRzn1xzZ2x0EA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Patrick Dung <mpatdung@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Thu, Feb 02, 2017 at 04:17:36AM +0800, Patrick Dung wrote:
> > It's also possible that the filesystem somehow got re-corrupted between
> the runs.
> 
> For my case, the write back SSD caching device was removed permanently.
> Somehow the xfs_repair did not fix all problems after the first pass.

Just because the SSD caching device was not re-attached to the system, it
doesn't mean the filesystem couldn't have been corrupted again, which is most
likely the case, but it would be a nice idea if you check the xfsprogs version
you used on the first and second time, just to make sure there were no known
bugs on that that might have caused this.

Cheers.

> 
> Best regards,
> Patrick
> 
> On Thu, Feb 2, 2017 at 3:58 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> > On 2/1/17 12:53 PM, Patrick Dung wrote:
> >> Hi guys,
> >>
> >> The problem happened in last year. I do not have the corrupted file
> >> system now. But I would like to discuss it. Any comment is welcomed.
> >>
> >> I was using Fedora 24. I had an XFS file system in an hard drive. I
> >> had used some kind of  SSD write back caching on top of the hard
> >> drive.
> >>
> >> Somehow the SSD was removed and when the system is rebooted, the XFS
> >> file system could not be mounted.
> >>
> >> I run xfs_repair, it reported some files are corrupted. It had
> >> completed the repair of file system and some files were corrupted.
> >> Then I could mount the filesystem. I started using the existing files
> >> that did not have corruption. After sometime, the file system stopped
> >> again because it detected XFS file system is corrupted.
> >>
> >> Then I run xfs_repair again and it found additional files were still corrupted.
> >>
> >> So I have a question if xfs_repair is able to fully detect all files
> >> that are corrupted by running xfs_repair only once.
> >
> > Yes, xfs_repair is intended to fix everything on the first pass.  Rarely,
> > there are bugs when it does not.
> >
> > It's also possible that the filesystem somehow got re-corrupted between
> > the runs.
> >
> > -Eric
> >
> >> Best regards,
> >> Patrick
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
