Return-Path: <geir.myrestrand@falconstor.com>
Message-ID: <45788927.4030207@falconstor.com>
Date: Thu, 07 Dec 2006 16:35:35 -0500
From: "Geir A. Myrestrand" <geir.myrestrand@falconstor.com>
Reply-To: geir.myrestrand@falconstor.com
MIME-Version: 1.0
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
References: <4560AB84.9060200@sandeen.net> <45784E71.4080605@falconstor.com>	 <457854CB.5030507@sandeen.net>  <45787ED4.5070801@falconstor.com> <1165525906.30459.25.camel@edge>
In-Reply-To: <1165525906.30459.25.camel@edge>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: xfs@oss.sgi.com
Cc: nscott@aconex.com, Eric Sandeen <sandeen@sandeen.net>
List-ID: <xfs>

Nathan Scott wrote:
> Does it happen with mainline (current) kernels?  This is ringing some
> distant bells, something to do with an atomic_inc being in the wrong
> spot in [_]xfs_trans_alloc ... or maybe a wrong call to xfs_trans_alloc
> instead of the '_' prefixed version - details are murky now though.  I
> do remember fixing ... something in here, a few months back, that fix
> may not be in Eric's codebase yet.
> 
> cheers.

I've only tried this on RHELAS4 with the kernel shipped with Update 2. I 
have not tried to update the kernel, or install Update 4 or whatever is 
current now. My kernel is 2.6.9-22.ELsmp.

It wouldn't be easy for me to switch to a newer kernel, because it is 
not just a matter of my machine --we have a product built for this 
particular configuration. Switching to a new kernel would reset our QA 
efforts.

If this may be fixed in the XFS modules on the other hand, then it would 
be awesome if we could get it resolved with an updated XFS package for 
RHEL4. I would be more than willing to put in an extra effort and work 
with anyone on this.

-- 

Geir A. Myrestrand
