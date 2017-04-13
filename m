Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48468 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751242AbdDMPuK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 11:50:10 -0400
Date: Thu, 13 Apr 2017 08:50:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfsprogs: update man for metadump about dirty
 log/obfuscation issue
Message-ID: <20170413155003.GV8502@birch.djwong.org>
References: <20170413081354.22170-1-jtulak@redhat.com>
 <20170413081354.22170-3-jtulak@redhat.com>
 <20170413120152.GB24893@bfoster.bfoster>
 <CACj3i70UdyecqPjxNG9c=7gWdi1sjigFAPQX+TWYP0omj_2WvQ@mail.gmail.com>
 <324004e7-6809-bca0-8c39-ac7d846d7238@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <324004e7-6809-bca0-8c39-ac7d846d7238@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Tulak <jtulak@redhat.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Apr 13, 2017 at 08:49:52AM -0500, Eric Sandeen wrote:
> On 4/13/17 7:29 AM, Jan Tulak wrote:
> > On Thu, Apr 13, 2017 at 2:01 PM, Brian Foster <bfoster@redhat.com> wrote:
> >> On Thu, Apr 13, 2017 at 10:13:54AM +0200, Jan Tulak wrote:
> >>> This is something that should be documented, as it is not obvious to
> >>> everyone.
> >>>
> >>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> >>> ---
> >>>  man/man8/xfs_metadump.8 | 6 ++++++
> >>>  1 file changed, 6 insertions(+)
> >>>
> >>> diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
> >>> index 3731d6a..1b40fb8 100644
> >>> --- a/man/man8/xfs_metadump.8
> >>> +++ b/man/man8/xfs_metadump.8
> >>> @@ -59,6 +59,12 @@ options where
> >>>  are not obfuscated. Names between 5 and 8 characters in length inclusively
> >>>  are partially obfuscated.
> >>>  .PP
> >>> +Log recovery of an obfuscated metadata image can leak
> >>> +unobfuscated metadata and/or cause image corruption. Please mount
> >>> +the source filesystem to clean the log or disable obfuscation, if possible.
> >>> +If you have to obfuscate an image with a dirty log, tell about it to whoever
> >>> +you are sending the image to.
> >>> +.PP
> >>
> >> We might want the man page content to be a bit more descriptive than
> >> what xfs_metadump actually emits for a warning. For example:
> >>
> >> "xfs_metadump does not obfuscate data in the filesystem log. Log
> >> recovery of an obfuscated metadump image may expose unobfuscated
> >> metadata and/or cause filesystem corruption. It is recommended to
> >> disable obfuscation for filesystems that must be captured with a dirty
> >> log."
> >>
> >> ... but that's just my .02. Feel free to reword that and solicit more
> >> feedback from others too. Another thought here could be to intimate that
> >> if an obfuscated+dirty log metadump image is truly required, it is the
> >> user responsibility to verify that the resulting image has not been
> >> corrupted by the metadump process and does not contain sensitive
> >> metadata (as opposed to telling the user to simply tell the recipient of
> >> the image about it).
> >>
> > 
> > Sounds reasonable, so how about these two paragraphs?
> > 
> >> "xfs_metadump does not obfuscate data
> 
> metadata
> 
> >> in the filesystem log. Log
> >> recovery of an obfuscated metadump image may expose unobfuscated
> >> metadata and/or cause filesystem corruption.
> 
> I would add "in the restored image." so that it does not sound like
> damage to the original filesystem could result.
> 
> > It is recommended to
> >> disable obfuscation for filesystems that must be captured with a dirty
> >> log.
> > 
> > If it is necessary to use obfuscation for any reason
> 
> drop "for any reason" - just makes this long text longer...
> 
> > and the source fileystem
> > can't be mounted to clean the log, the resulting image should be tested for
> > any corruption caused by metadump process and any sensitive information
> > in the log and the recipient of the image informed about the result."
> 
> The end-user running metadump may not have the expertise to "test the resulting
> image for any corruption ..."  - they're probably just following some support
> person's instructions to "run this command..."  How about this:

(Or they're just running some crazy hoover-up-all-the-state script that
support gave them. ;))

> ---
> 
> xfs_metadump cannot obfuscate metadata in the filesystem log.  Log
> recovery of an obfuscated metadump image may expose clear-text
> metadata and/or cause filesystem corruption in the restored image.
> It is recommended that the source filesystem be mounted and unmounted
> first if possible, to produce a metadump with a clean log.

"It is recommended that the source filesystem first be mounted and
unmounted, if possible, to ensure that the log is clean.  That way, all
metadata can be obfuscated correctly and the metadump will capture a
clean log."

...because mounting and unmounting itself does not produce metadumps. :)

> If a metadump must be produced from a filesystem with a dirty log,
> it is recommended that obfuscation be turned off with -o option, if
> metadata such as filenames is not considered sensitive.  If obfuscation
> is required on a metadump with a dirty log, please inform the recipient
> of the metadump image about this situation.

Otherwise seems fine to me.

--D

> ---
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
