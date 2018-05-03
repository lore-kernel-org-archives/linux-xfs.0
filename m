Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46789 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751111AbeECM1E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 May 2018 08:27:04 -0400
Date: Thu, 3 May 2018 14:27:01 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [Patch 1/4] Support for checking and reading block grade
 information in kernel
Message-ID: <20180503122701.3tibc62mcqkjwcz6@quack2.suse.cz>
References: <CAExFE6m_jeBzmTUaYnEA7cZ-jbfogYXWPmjRPPJfR_5MvEWU5w@mail.gmail.com>
 <20180419154023.vyqgoop6q23cws76@quack2.suse.cz>
 <CAExFE6knuQNAF6RBDLLtqsRVratQVZ-1gjD_ZG9K0UhdrnFg5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAExFE6knuQNAF6RBDLLtqsRVratQVZ-1gjD_ZG9K0UhdrnFg5g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sayan Ghosh <sgdgp.2014@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org, niloy ganguly <ganguly.niloy@gmail.com>, "Bhattacharya, Suparna" <suparna.bhattacharya@hpe.com>, Madhumita Mallick <madhu.cse.ju@gmail.com>, "Bharde, Madhumita" <madhumita.bharde@hpe.com>, linux-xfs@vger.kernel.org

Hello Sayan,

On Sun 29-04-18 15:22:34, Sayan Ghosh wrote:
> Thank you for looking into our patchset and providing feedbacks.
> We are currently modifying these patches for the latest version of kernel.
> 
> The overall objective is described as follows :
> The goal of our project is broadly to support data gradation of a
> single file. If the contents of the file is graded in terms of its
> importance then a corresponding application might need to view/analyse
> only the important portions. It also helps if the important portions
> can be accessed quickly without having to go through the entire file.
> For an example, we can think of a leaning video with
> indexing/annotations, in which the annotations contain the important
> parts of the video. A learner can just be interested in those parts,
> and it will help him if he can be provided with a reduced view with
> just the parts he’s interested in. An example of such videos is ACM
> Webinar videos where an user can navigate using table-of-contents or
> phrase cloud.
> 
> The below link is one similar video -
> https://videoken.com/video-detail?videoID=IpGxLWOIZy4&videoDuration=1853&videoName=A%20Friendly%20Introduction%20to%20Machine%20Learning&keyword=A%20Friendly%20Introduction%20to%20Machine%20Learning
> 
> These kind of video file can serve as an input to our system where we
> know which parts of the file has been marked. Our goal then is to
> properly place respective important blocks and provide a reduced view
> of just the important parts of the file. Placing the important blocks
> in a faster tier (SSD,PM etc) greatly enhances the performance of
> reading and writing of the file.
> In order to achieve this we have a data structure for the grades -
> sort of like extent structure. It contains details of segments of high
> graded parts of the file. The contents of the data structure are the
> starting block number and the length of the segment.
> So the patches basically focus on having functions to set and get the
> grade information from the extended attributes and allocating the
> blocks using this grade information (by modifying the fallocate calls
> in the kernel). The aspect of getting a reduced view of the file is
> being handled by modifying the code for dax calls in kernel.
> Also taking clue from Andreas' feedback we are looking into the
> streamID interface to see if we can use this for our work.
> We are also looking if there are any other in-built methods which can
> help in having the grade structure without introducing new data
> structures. We would be grateful if you also could provide suggestions
> on other ways of implementing grades.

What you describe here really sounds pretty much like "Hiearchical Storage
Management" (HSM). It was invented a long time ago to support storage of
less used data on slow storage (tapes or so at that time). There's even a
standard for filesystems to support this and XFS used to support it (the
support in Linux was later removed as it was broken) - I think "Data
Storage Management (XDSM) API" [1] is the standard describing the API. I've
CCed XFS mailing list as people more knowledgeable of HSM than me are
lingering there :).

The difference of your proposal to classical HSM is in that in your
proposal, all the storage devices are directly accessible by the filesystem
and just mapped to different block offsets of the device underlying the
filesystem. Which frankly sounds quite messy as is also shown by you having
to hardcode where fast / slow device starts in the block number space.
Also your support for reading only highly graded info (patch 4) IMO does
not belong to the kernel. Userspace application can just read from some
index which parts of the file are interesting and use lseek(2) + read(2) to
read only those. No need for special kernel magic. Finally mixing DAX &
non-DAX access to a single file as you do in patch 3 is technically very
difficult (there are lots of assumptions in current DAX code that a file is
either wholy accessed through DAX or nothing is accessed through DAX). So
to sum it up won't you get better overall results, if you just used
something like dm-cache / bcache and cached the slow device with the fast
one?

								Honza

[1] http://pubs.opengroup.org/onlinepubs/9657099/

> 
> Regards,
> Sayan
> 
> On Thu, Apr 19, 2018 at 9:10 PM, Jan Kara <jack@suse.cz> wrote:
> > On Fri 06-04-18 17:11:40, Sayan Ghosh wrote:
> >> This introduces the different functions in order to get the grades as
> >> the extended attributes while pre-allocating a new file. The grades
> >> are stored as extended attributes while the file gets created. The
> >> grades can be used by different user space applications as necessary.
> >> The functions introduced are read_grade_xattr(), is_file_graded(),
> >> read_count_xattr() which aim to read the extended attribute for grade
> >> array and also to know whether the file is graded. The detailed
> >> descriptions of the functions are provided as comments in the patch.
> >> The patch is on top of Linux Kernel 4.7.2.
> >>
> >> Signed-off-by: Sayan Ghosh <sgdgp.2014@gmail.com>
> >
> > Thanks for the patch! The fact that this is based on rather old kernel has
> > been already mentioned - you really need to base on much newer kernel to
> > get this merged. Another problem I see is that there's no description of
> > the design of this feature. I.e., What this feature is good for? And how is
> > it supposed to work? Probably before investing too much time into rebasing
> > you can start with sending the high level design of the feature for
> > discussion. From quickly glancing through the patches I gather it is some
> > kind of HSM but I'm not completely sure...
> >
> >                                                                 Honza
> >
> >> ---
> >>  fs/ext4/ext4.h    | 15 +++++++++++++++
> >>  fs/ext4/extents.c | 35 +++++++++++++++++++++++++++++++++++
> >>  2 files changed, 50 insertions(+)
> >>
> >> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> >> index b84aa1c..b9ec0ca 100755
> >> --- a/fs/ext4/ext4.h
> >> +++ b/fs/ext4/ext4.h
> >> @@ -136,6 +136,18 @@ enum SHIFT_DIRECTION {
> >>  /* Use blocks from reserved pool */
> >>  #define EXT4_MB_USE_RESERVED        0x2000
> >>
> >> +/* Structure of a grade - starting block number
> >> + * and length of contiguous blocks with same higher
> >> + * grade (inclusive of starting block)
> >> + * example : if blocks 2,3,4 are higher graded,
> >> + * then block_num = 2 and len = 3
> >> + * Only high grade information is stored by this struct.
> >> + */
> >> +struct grade_struct {
> >> +    ext4_lblk_t block_num;
> >> +    unsigned long long len;
> >> +};
> >> +
> >>  struct ext4_allocation_request {
> >>      /* target inode for block we're allocating */
> >>      struct inode *inode;
> >> @@ -3186,6 +3198,9 @@ extern int ext4_check_blockref(const char *, unsigned int,
> >>  /* extents.c */
> >>  struct ext4_ext_path;
> >>  struct ext4_extent;
> >> +extern unsigned long long read_count_xattr(struct inode *inode);
> >> +extern void read_grade_xattr(struct inode *inode,struct grade_struct
> >> *grade_array);
> >> +extern int is_file_graded(struct inode *inode);
> >>
> >>  /*
> >>   * Maximum number of logical blocks in a file; ext4_extent's ee_block is
> >> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> >> index d7ccb7f..de9194f 100755
> >> --- a/fs/ext4/extents.c
> >> +++ b/fs/ext4/extents.c
> >> @@ -57,6 +57,41 @@
> >>  #define EXT4_EXT_DATA_VALID1    0x8  /* first half contains valid data */
> >>  #define EXT4_EXT_DATA_VALID2    0x10 /* second half contains valid data */
> >>
> >> +/*
> >> + * read_grade_xattr() is used to read the grade array from the
> >> extended attribute.
> >> + */
> >> +void read_grade_xattr(struct inode *inode,struct grade_struct *grade_array)
> >> +{
> >> +    const char *xattr_name = "grade_array";
> >> +    int xattr_size = ext4_xattr_get(inode,
> >> EXT4_XATTR_INDEX_USER,xattr_name, NULL,0);
> >> +    xattr_size = ext4_xattr_get(inode,
> >> EXT4_XATTR_INDEX_USER,xattr_name, (void *)grade_array,xattr_size);
> >> +    return;
> >> +}
> >> +
> >> +/*
> >> + * is_file_graded() returns whether the file has a grade information or not.
> >> + * It takes the inode number as a parameter.
> >> + */
> >> +int is_file_graded(struct inode *inode)
> >> +{
> >> +    const char *xattr_name = "is_graded";
> >> +    int is_graded = 0;
> >> +    int xattr_size = sizeof(int);
> >> +    xattr_size = ext4_xattr_get(inode,
> >> EXT4_XATTR_INDEX_USER,xattr_name, (void *)&amp;is_graded,xattr_size);
> >> +    return is_graded;
> >> +}
> >> +
> >> +/*
> >> + * read_count_xattr() used to get the number of the elements in the
> >> grade array.
> >> + */
> >> +unsigned long long read_count_xattr(struct inode *inode)
> >> +{
> >> +    const char *xattr_name = "grade_array";
> >> +    unsigned long long xattr_size = ext4_xattr_get(inode,
> >> EXT4_XATTR_INDEX_USER,xattr_name, NULL,0);
> >> +    unsigned long long total = xattr_size/sizeof(struct grade_struct);
> >> +    return total;
> >> +}
> >> +
> >>  static __le32 ext4_extent_block_csum(struct inode *inode,
> >>                       struct ext4_extent_header *eh)
> >>  {
> >> ‌
> > --
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR
> 
> </jack@suse.com></sgdgp.2014@gmail.com></jack@suse.cz>
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
