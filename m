Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1ACF629DF8
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 22:03:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B203CAC005
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 20:03:55 -0800 (PST)
Received: from mail-qa0-f45.google.com (mail-qa0-f45.google.com
	[209.85.216.45]) by cuda.sgi.com with ESMTP id RsqnSYZVkSMuMiWj
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 26 Feb 2014 20:03:54 -0800 (PST)
Received: by mail-qa0-f45.google.com with SMTP id m5so3512376qaj.18
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 20:03:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140226164827.GB11452@thunk.org>
References: <1392908861-3563-1-git-send-email-linkinjeon@gmail.com>
	<20140222170930.GE26637@thunk.org>
	<CAKYAXd9vTbjTnJOQ1Y=pi4QJSYj41fWsQgRD3Fkufskez2W-YA@mail.gmail.com>
	<20140226164827.GB11452@thunk.org>
Date: Thu, 27 Feb 2014 13:03:53 +0900
Message-ID: <CAKYAXd_4-BUiRMLfZ97vToSb4xuRj0zz=uvUc-w3cjcs3wM85g@mail.gmail.com>
Subject: Re: [PATCH v6] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Cc: Namjae Jeon <linkinjeon@gmail.com>, jack@suse.cz, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, lczerner@redhat.com, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

2014-02-27 1:48 GMT+09:00, Theodore Ts'o <tytso@mit.edu>:
> On Mon, Feb 24, 2014 at 10:22:10AM +0900, Namjae Jeon wrote:
>> >> +	ret = ext4_es_remove_extent(inode, punch_start,
>> >> +				    EXT_MAX_BLOCKS - punch_start - 1);
>> >> +	if (ret) {
>> >> +		up_write(&EXT4_I(inode)->i_data_sem);
>> >> +		goto out_stop;
>> >> +	}
>> >
>> > Doing this at first is probably a bad idea; you should do this at the
>> > end, and then completely invalidate the es cache for that inode.  That
>> > way, the right thing happens if you get an error in the middle
>> > releasing the boxes and shifting the extents:
>> Okay, I see.
>
> Actually, thinking about this some more, we do want to do this first,
> since if we error out, we do need to make sure the extent cache is
> flushed.
Okay.

>
>> If there is error in the middle of extent shifting, the hole will
>> present between the last shifted extent and the extent at which error
>> happen so this will be consistent state.
>> IMHO even if there is error in between the shift, filesystem will be
>> in consistent state.
>> Am I missing something?
>
> No, I was wrong about that; you're right.  The file will be in an
> inconsistent statement, which will probably be highly confusing for
> the application, but the file system will be fine.
>
> So I withdraw my complaints.  I'll do a bit more testing, but so far
> the patch looks fine to me.  Thanks for your reply and your work!
Thanks for your review! I will fix these include Hugh's review points.
>
> 					- Ted
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
