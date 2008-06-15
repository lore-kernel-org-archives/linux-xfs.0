Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jun 2008 09:08:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5FG8Ghs011814
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 09:08:16 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86027CBD058
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 09:09:12 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159]) by cuda.sgi.com with ESMTP id 04WICle1BBDffa8P for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 09:09:12 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id l26so3255420fgb.8
        for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 09:09:11 -0700 (PDT)
Message-ID: <6101e8c40806150909s4f9b95d2u685c09a0ba3767e3@mail.gmail.com>
Date: Sun, 15 Jun 2008 18:09:11 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
Subject: Re: XFS errors / BUG / panic, with 2.6.25.7-queue (and older 2.6.25.y)
In-Reply-To: <48553C11.2060606@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40806141241h4a23f7a6ka5366c84130f1291@mail.gmail.com>
	 <48547604.9060700@sandeen.net>
	 <6101e8c40806150538h4372dcedob2ab9c45aa01741c@mail.gmail.com>
	 <48553C11.2060606@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

this is the debian way of the unmounting the root fs:
do_stop () {
        [ "$VERBOSE" = no ] || log_action_begin_msg "Mounting root filesystem re
ad-only"
        MOUNT_FORCE_OPT=
        [ "$(uname -s)" = "GNU/kFreeBSD" ] && MOUNT_FORCE_OPT=-f
        # This:
        #     mount -n -o remount,ro /
        # will act on a bind mount of / if there is one.
        # See #339023 and the comment in checkroot.sh
        mount    $MOUNT_FORCE_OPT -n -o remount,ro -t dummytype dummydev / 2>/de
v/null \
        || mount $MOUNT_FORCE_OPT -n -o remount,ro              dummydev / 2>/de
v/null \
        || mount $MOUNT_FORCE_OPT -n -o remount,ro                       /
        ES=$?
        [ "$VERBOSE" = no ] || log_action_end_msg $ES
}


On 6/15/08, Eric Sandeen <sandeen@sandeen.net> wrote:
> Oliver Pinter wrote:
>> this mistake shutdownkor comes out, remount launched because he
>> panics, only Alt+Sysrq+foo works
>
> I'm not sure I follow.
>
> Assuming that :
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00775.jpg
>
> is the first event of interest, it is hitting an assertion on the
> remount path:
>
>         ASSERT_ALWAYS(atomic_read(&mp->m_active_trans) == 0);
>
> in xfs_attr_quiesce.
>
> Are you saying something else happen before this?  If so, what?
>
> -Eric
>
>> On 6/15/08, Eric Sandeen <sandeen@sandeen.net> wrote:
>>> Oliver Pinter wrote:
>>>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00775.jpg
>>>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00776.jpg
>>>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00777.jpg
>>>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00778.jpg
>>>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00779.jpg
>>>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00780.jpg
>>>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00781.jpg
>>>>
>>>> tainted with: nvidia and madwifi
>>>> kernel: 2.6.25.6 + queue patches (queue head on
>>>> aa8edcb997ff605bd1424630356866b78ef06cdc)
>>>>
>>> What sort of remount were you doing?
>>>
>>> -Eric
>>>
>>
>>
>
>


-- 
Thanks,
Oliver
