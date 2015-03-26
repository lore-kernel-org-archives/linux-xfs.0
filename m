Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8672E7F50
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2015 10:47:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 63AE38F804B
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2015 08:47:08 -0700 (PDT)
Received: from mx141.netapp.com (mx141.netapp.com [216.240.21.12]) by
	cuda.sgi.com with ESMTP id OVHcvFmZYIQulBod (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Mar 2015 08:47:07 -0700 (PDT)
Message-ID: <551429F7.5050305@Netapp.com>
Date: Thu, 26 Mar 2015 11:47:03 -0400
From: Anna Schumaker <Anna.Schumaker@netapp.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 3/3] NFSD: Add support for encoding multiple segments
References: <OFB111A6D8.016B8BD5-ON88257E0D.001D174D-88257E0D.005268D6@us.ibm.com>
	<20150319153627.GA20852@fieldses.org>
	<OF38D4D18B.19055EC2-ON88257E0D.0059BA03-88257E0D.005A781F@us.ibm.com>
	<20150320151718.GD2036@fieldses.org>
	<20150320162303.GA18786@infradead.org>
	<20150320182621.GH2036@fieldses.org>
	<CAFX2JfkybBPcqD6A8r-jOkPnkL26=NEuK3zhA6TLn-DVam+kfQ@mail.gmail.com>
	<20150324174916.GA28906@infradead.org>
	<55142405.3090000@Netapp.com>
	<CAHQdGtTavsJ5k0taRCBi7CgP1NYjqQmgbQcE-yUkXQOKdQsGpA@mail.gmail.com>
	<20150326153848.GB30482@fieldses.org>
In-Reply-To: <20150326153848.GB30482@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>, Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, Marc Eshel <eshel@us.ibm.com>, linux-nfs-owner@vger.kernel.org, xfs@oss.sgi.com

On 03/26/2015 11:38 AM, J. Bruce Fields wrote:
> On Thu, Mar 26, 2015 at 11:32:25AM -0400, Trond Myklebust wrote:
>> On Thu, Mar 26, 2015 at 11:21 AM, Anna Schumaker
>> <Anna.Schumaker@netapp.com> wrote:
>>> Here are my updated numbers!  I tested with files 5G in size: one 100% data, one 100% hole, and one alternating between hole and data every 4K.  I collected data for both v4.1 and v4.2 with and without the READ_PLUS patches:
>>>
>>> ##########################
>>> #                        #
>>> #   Without READ_PLUS    #
>>> #                        #
>>> ##########################
>>>
>>>
>>> NFS v4.1:
>>>                             Trial
>>> |---------|---------|---------|---------|---------|---------|---------|
>>> |         |    1    |    2    |    3    |    4    |    5    | Average |
>>> |---------|---------|---------|---------|---------|---------|---------|
>>> |    Data |  8.723s |  7.243s |  8.252s |  6.997s |  6.980s |  7.639s |
>>> |    Hole |  5.271s |  5.224s |  5.060s |  4.897s |  5.321s |  5.155s |
>>> |   Mixed |  8.050s | 10.057s |  7.919s |  8.060s |  9.557s |  8.729s |
>>> |---------|---------|---------|---------|---------|---------|---------|
>>>
>>>
>>>
>>>
>>> NFS v4.2:
>>>                             Trial
>>> |---------|---------|---------|---------|---------|---------|---------|
>>> |         |    1    |    2    |    3    |    4    |    5    | Average |
>>> |---------|---------|---------|---------|---------|---------|---------|
>>> |    Data |  6.707s |  7.070s |  6.722s |  6.761s |  6.810s |  6.814s |
>>> |    Hole |  5.152s |  5.149s |  5.213s |  5.206s |  5.312s |  5.206s |
>>> |   Mixed |  7.979s |  7.985s |  8.177s |  7.772s |  8.280s |  8.039s |
>>> |---------|---------|---------|---------|---------|---------|---------|
>>>
>>>
>>>
>>>
>>>
>>> #######################
>>> #                     #
>>> #   With READ_PLUS    #
>>> #                     #
>>> #######################
>>>
>>>
>>> NFS v4.1:
>>>                             Trial
>>> |---------|---------|---------|---------|---------|---------|---------|
>>> |         |    1    |    2    |    3    |    4    |    5    | Average |
>>> |---------|---------|---------|---------|---------|---------|---------|
>>> |    Data |  9.082s |  7.008s |  7.116s |  6.771s |  7.902s |  7.576s |
>>> |    Hole |  5.333s |  5.358s |  5.380s |  5.161s |  5.282s |  5.303s |
>>> |   Mixed |  8.189s |  8.308s |  9.540s |  7.937s |  8.420s |  8.479s |
>>> |---------|---------|---------|---------|---------|---------|---------|
>>>
>>>
>>>
>>>
>>> NFS v4.2:
>>>                             Trial
>>> |---------|---------|---------|---------|---------|---------|---------|
>>> |         |    1    |    2    |    3    |    4    |    5    | Average |
>>> |---------|---------|---------|---------|---------|---------|---------|
>>> |    Data |  7.033s |  6.829s |  7.025s |  6.873s |  7.134s |  6.979s |
>>> |    Hole |  1.794s |  1.800s |  1.905s |  1.811s |  1.725s |  1.807s |
>>> |   Mixed |  7.590s |  8.777s |  9.423s | 10.366s |  8.024s |  8.836s |
>>> |---------|---------|---------|---------|---------|---------|---------|
>>>
>>
>> So there is a clear win in the 100% hole case here, but otherwise the
>> statistical fluctuations are dominating the numbers. Can you get us a
>> little more stats and then perhaps run the results through nfsometer?
> 
> Also, could you describe the setup (are these still kvm's), and how
> you're clearing the cache between runs?

These are still KVMs and my server is exporting an xfs filesystem.  I clear caches by running "echo 3 > /proc/sys/vm/drop_caches" on the server before every read, and I remount my client after reading each set of three files once.

> 
> --b.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
