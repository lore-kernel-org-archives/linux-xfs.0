Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3892A7FB0
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 08:34:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 183448F8033
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 06:34:05 -0700 (PDT)
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	by cuda.sgi.com with ESMTP id L8gK0eV2bSObhdjC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 06:34:03 -0700 (PDT)
From: "Zuckerman, Boris" <borisz@hp.com>
Subject: RE: [RFC v2] Unicode/UTF-8 support for XFS
Date: Thu, 25 Sep 2014 13:33:09 +0000
Message-ID: <4C30833E5CDF444D84D942543DF65BDA6E045594@G4W3303.americas.hpqcorp.net>
References: <20140918195650.GI19952@sgi.com> <20140922222611.GZ4322@dastard>
	<5422C540.1060007@sgi.com> <20140924231024.GA4758@dastard>
In-Reply-To: <20140924231024.GA4758@dastard>
Content-Language: en-US
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>, Olaf Weber <olaf@sgi.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Ben Myers <bpm@sgi.com>, "tinguely@sgi.com" <tinguely@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>



> -----Original Message-----
> From: linux-fsdevel-owner@vger.kernel.org [mailto:linux-fsdevel-
> owner@vger.kernel.org] On Behalf Of Dave Chinner
> Sent: Wednesday, September 24, 2014 7:10 PM
> To: Olaf Weber
> Cc: Ben Myers; linux-fsdevel@vger.kernel.org; tinguely@sgi.com; xfs@oss.sgi.com
> Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
> 
> On Wed, Sep 24, 2014 at 03:21:04PM +0200, Olaf Weber wrote:
> > On 23-09-14 00:26, Dave Chinner wrote:
> > >On Thu, Sep 18, 2014 at 02:56:50PM -0500, Ben Myers wrote:
> >
> > [...]
> >
> > >>TODO: Store the unicode version number of the filesystem on disk in
> > >>the super block.
> > >
> > >So, if the filesystem has to store the specific unicode version it
> > >was created with so that we know what version to put in trie lookups,
> > >again I'll ask: why are we loading the trie as a generic kernel
> > >module and not as metadata in the filesystem that is demand paged and
> > >cached?
> >
> > This way the trie can be shared, and the code using it is not
> > entangled with the XFS code.
> 
> The trie parsing code can still be common - just the location and contents of the data is
> determined by the end-user.
> 

Both these approaches can co-exists (as I recall was done in Windows). A system may have "a default trie" and a caller (name space) can provide its own...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
