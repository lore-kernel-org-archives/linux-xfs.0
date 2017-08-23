Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60090 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751092AbdHWWg2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Aug 2017 18:36:28 -0400
Subject: Re: [PATCH 1/4] fiemap: Move global variables out of function scope
References: <5fc15693-7df3-c1bf-9f78-020eed30b567@sandeen.net>
 <1503501082-16983-1-git-send-email-nborisov@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e6ca6543-2ca0-f3d3-06b1-f792197de024@sandeen.net>
Date: Wed, 23 Aug 2017 17:36:27 -0500
MIME-Version: 1.0
In-Reply-To: <1503501082-16983-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org

On 8/23/17 10:11 AM, Nikolay Borisov wrote:
> Move the blocksize and max_extent variables to the top of the file since they
> are globals. Also blocksize never changes to mark it const. Also stop passing
> max_extents around and refer to it directly.

Having looked at this for way too long, here are things that I think could be
done, in more or less this order as separate patches, but rearrange or
add/remove as you see fit...

- Get rid of the blocksize variable, and use BTOBBT()
- Turn num_extents into #define EXTENT_BATCH 32, fixed query map size
- make max_extents global if you like
- Clean up the control loop(s) and exit point(s), there are now exits on:
  + fm_mapped_extents == 0 (we got none from our query)
  + FIEMAP_EXTENT_LAST set (kernel tells us this one is last)
  + max_extents hit (we hit the user's limit)
  + end of requested range hit (after range is implemented)
  ... there's a lot in there that is messy. :/
- Fix the "-n" behavior (a minimally as possible) and update xfs_bmap(8) to match

finally:

- Implement your range query (I think this can be done by simply
  modifying the initial fm_start and fm_length, no?  Or, by only
  modifying fm_start, and breaking out of the loop when we retrieve
  an extent that goes beyond the end of the requested region?)

Other things I noticed:

- print_plain and print_verbose are pretty nasty the way they
  hide increments of cur_extent & last_logical.  I think it would
  be better to:

   + pass cur_extent & last_logical by value
   + return nr of extents printed, so the caller can increment cur_extent
   + update last_logical in fiemap_f after, not in, the print functions

- The last hunk that handles a hole at EOF is ick; something like this
  may be better, re-using the print functions with a special "EOF
  extent"; the print functions would then return after printing a hole
  if they are handed a 0 length extent with LAST set, or something.

        /* Handle a hole at EOF if there is one */
        if (cur_extent && last_logical < st.st_size) {
                struct fiemap_extent hole = { 0 };

                /* special 0-length extent to show formatters it's hole @ EOF */
                hole.fe_logical = st.st_size;
                hole.fe_length = 0;
                hole.fe_flags = FIEMAP_EXTENT_LAST;

                if (vflag)
                        print_verbose(&hole, foff_w, boff_w, tot_w, flg_w,
                                      max_extents, cur_extent, last_logical);
                else
                        print_plain(&hole, lflag,
                                    max_extents, cur_extent, last_logical);
        }

