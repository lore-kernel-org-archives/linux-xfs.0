Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48215 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbdHSA6t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Aug 2017 20:58:49 -0400
Date: Fri, 18 Aug 2017 17:58:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC 00/12] xfs: more and better verifiers
Message-ID: <20170819005816.GO4796@magnolia>
References: <150301268960.5851.2513223883233763065.stgit@magnolia>
 <20170818070516.GA15291@infradead.org>
 <20170818170607.GK4796@magnolia>
 <20170818184511.GL4796@magnolia>
 <20170819003300.GL10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170819003300.GL10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Sat, Aug 19, 2017 at 10:33:00AM +1000, Dave Chinner wrote:
> On Fri, Aug 18, 2017 at 11:45:11AM -0700, Darrick J. Wong wrote:
> > On Fri, Aug 18, 2017 at 10:06:07AM -0700, Darrick J. Wong wrote:
> > > On Fri, Aug 18, 2017 at 12:05:16AM -0700, Christoph Hellwig wrote:
> > > > On Thu, Aug 17, 2017 at 04:31:29PM -0700, Darrick J. Wong wrote:
> > > > > Hi all,
> > > > > 
> > > > > This RFC combines all the random little fixes and improvements to the
> > > > > verifiers that we've been talking about for the past month or so into a
> > > > > single patch series!
> > > > > 
> > > > > We start by refactoring the long format btree block header verifier into
> > > > > a single helper functionn and de-macroing dir block verifiers to make
> > > > > them less shouty.  Next, we change verifier functions to return the
> > > > > approximate instruction pointer of the faulting test so that we can
> > > > > report more precise fault information to dmesg/tracepoints.
> > > > 
> > > > Just jumping here quickly because I don't have time for a detailed
> > > > review:
> > > > 
> > > > How good does this instruction pointer thing resolved to the actual
> > > > issue?
> > > 
> > > Ugh, it's terrible once you turn on the optimizer.
> > > 
> > >         if (!xfs_sb_version_hascrc(&mp->m_sb))                                  
> > >                 return __this_address;                                          
> > >         if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))        
> > >                 return __this_address;                                          
> > >         if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))                    
> > >                 return __this_address;                                          
> > >         if (pag && be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)        
> > >                 return __this_address;                                          
> > >         return NULL;                                                            
> > > 
> > > becomes:
> > > 
> > >         if (!xfs_sb_version_hascrc(&mp->m_sb))                                  
> > >                 goto out;                                          
> > >         if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))        
> > >                 goto out;                                          
> > >         if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))                    
> > >                 goto out;                                          
> > >         if (pag && be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)        
> > >                 goto out;                                          
> > >         return NULL;                                                            
> > > out:
> > > 	return __this_address;
> > > 
> > > ...which is totally worthless, unless we want to compile all the verifier
> > > functions with __attribute__((optimize("O0"))), which is bogus.
> > > 
> > > <sigh> Back to the drawing board on that one.
> > 
> > Ok, there's /slightly/ less awful way to prevent gcc from optimizing the
> > verifier function to the point of imprecise pointer value, but it involves
> > writing to a volatile int:
> > 
> > /* stupidly prevent gcc from over-optimizing getting the instruction ptr */
> > extern volatile int xfs_lineno;
> > #define __this_address ({ __label__ __here; __here: xfs_lineno = __LINE__; &&__here; })
> > 
> > <grumble> Yucky, but it more or less works.
> 
> Can you declare the label as volatile, like you can an asm
> statement to prevent the compiler from optimising out asm
> statements?
> 
> Even so, given the yuckiness is very isolated and should only affect
> the slow path code, I can live with this.

Hmmm.  I can't declare the label as volatile, but I /can/ inject
asm volatile("") and that seems to prevent gcc from moving code hunks
around:

#define __this_address	({ __label__ __here; __here: asm volatile(""); &&__here; })

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
