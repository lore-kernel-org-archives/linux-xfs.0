Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34326 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750969AbdFVQpy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jun 2017 12:45:54 -0400
Subject: Re: Please consider a better error message for this error
References: <324e8bdc-b8d0-29d1-3cd2-f2441e4507ff@zoho.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6d06ccc0-c2dd-043e-82b8-00f218ae1f56@sandeen.net>
Date: Thu, 22 Jun 2017 11:45:52 -0500
MIME-Version: 1.0
In-Reply-To: <324e8bdc-b8d0-29d1-3cd2-f2441e4507ff@zoho.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Todd Chester <ToddAndMargo@zoho.com>, linux-xfs@vger.kernel.org

On 6/21/17 11:32 PM, Todd Chester wrote:
> Dear XFS Developers,
> 
> The staff on Red Hat's bugzilla asked me if I would post
> this kind of stuff "upstream".  I hope I have the right place.
> 
> Would one of our intrepid heroes please modifying the
> following incomprehensible error message?
> 
> root@rn4 lin-bak]# xfsrestore -R -i -f 2017-06-17_14-47-46_homeXfsDump /home
> xfsrestore: using file dump (drive_simple) strategy
> xfsrestore: version 3.1.4 (dump format 3.0) - type ^C for status and control
> xfsrestore: ERROR: -i valid only when initiating restore
> xfsrestore: Restore Status: ERROR
> 
> [root@rn4 lin-bak]# xfsrestore -Q -i -f 2017-06-17_14-47-46_homeXfsDump /home
> xfsrestore: using file dump (drive_simple) strategy
> xfsrestore: version 3.1.4 (dump format 3.0) - type ^C for status and control
> xfsrestore: ERROR: -i valid only when initiating restore
> xfsrestore: Restore Status: ERROR
> 
> 
> So basically you have to use a restore program when you are already using a restore program.  Huh ????  `jmp 0` ???

I guess if I squint, I can see how you might read it that way, but what this
means is that "-i" interactive is only valid when /initiating/ a new restore,
not when /resuming/ (-R) an interrupted restore.

But obviously it was confusing to you, and more clarity is better.

> 
> Would you please consider altering the error message to:
> 
>    xfsrestore: ERROR: -i (interactive) option not valid when
>                invoked with -R or -Q options

That's reasonable, and more clear I agree.  The trick here is that there
are 15 "valid only when initiating restore" messages in all, each under
a different conflicting option/mode.  And because xfsdump was written
by an alien species which has long since departed our planet, the code
is not well known to anyone and difficult to read; there are no actual
option conflicts stated, these messages come about as a result of post-
option-parsing state.  i.e.:

                if ( tranp->t_reqdumplabvalpr ) {
                        mlog( MLOG_NORMAL | MLOG_ERROR, _(
                              "-%c valid only when initiating restore\n"),
                              GETOPT_DUMPLABEL );
                        return BOOL_FALSE;
                }

so if "t_reqdumplabvalpr" is not NULL (which apparently was named via
someone's cat walking over the keyboard), then we say "-L valid only..."

and if:

                if ( tranp->t_reqdumpidvalpr ) {
                        mlog( MLOG_NORMAL | MLOG_ERROR, _(
                              "-%c valid only when initiating restore\n"),
                              GETOPT_SESSIONID );
                        return BOOL_FALSE;
                }

then we say "-S valid only ..." etc, for 15 different cases, each of which
needs to map state back to the option which set it, and added to the
error message.  Not impossible but it'll take a bit of time to go through and map
everything back, so I'll need to add this to the list of "nice to haves" for
now.

The conflict checking is inscrutable enough that this would take a fair amount
of time to make sure that each conflict message correctly conveys the
conflicting options.

> or something similar?
> 
> There are man page addition that should go along with this.  I
> sent them in another post.
> 
> If I am reading the source code correctly, the fix can be made at
> 
> from the following SRPM's tar ball, content.c
> http://rpm.pbone.net/index.php3/stat/26/dist/95/size/857409/name/xfsdump-3.1.4-1.el7.src.rpm
> 
> 
> 
> Old:
> 
> 1513        if ( tranp->t_reqdumplabvalpr ) {
> 1514            mlog( MLOG_NORMAL | MLOG_ERROR, _(
> 1515                  "-%c valid only when initiating restore\n"),
> 1516                  GETOPT_DUMPLABEL );
> 1617            return BOOL_FALSE;
> 1518        }

Actually these lines are testing against the "-L" option, not "-i" which shows
how easy it is to get this stuff wrong ;)

> 
> Revised:
> 
> 1513        if ( tranp->t_reqdumplabvalpr ) {
> 1514            mlog( MLOG_NORMAL | MLOG_ERROR, _(
> 1515                  "-%c (interactive) option not valid when invoked with -R or -Q options\n"),
> 1516                  GETOPT_DUMPLABEL );
> 1617            return BOOL_FALSE;
> 1518        }
> 
> 
> 
> I sincerely appreciate your consideration in the matter.
> 
> Many thanks,
> -T
> 
> 
> 
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
