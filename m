Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C799E7F3F
	for <xfs@oss.sgi.com>; Wed, 15 Apr 2015 14:32:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2480DAC004
	for <xfs@oss.sgi.com>; Wed, 15 Apr 2015 12:32:09 -0700 (PDT)
Received: from mx142.netapp.com (mx142.netapp.com [216.240.21.19]) by
	cuda.sgi.com with ESMTP id PJRkU60wgtcDw10H (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Apr 2015 12:32:07 -0700 (PDT)
Message-ID: <552EBCB2.1040609@Netapp.com>
Date: Wed, 15 Apr 2015 15:32:02 -0400
From: Anna Schumaker <Anna.Schumaker@netapp.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 3/3] NFSD: Add support for encoding multiple segments
References: <20150326153848.GB30482@fieldses.org> <551429F7.5050305@Netapp.com>
	<CAHQdGtRCrrhdS8F4FjZFT-CnRRGm8eZR07v8WnK7bwagKgmPcw@mail.gmail.com>
	<55142FB4.2070408@Netapp.com>
	<CAHQdGtS_VuBOzRZjsiYdjZS8qMj2Sw65BYdFmWWf-LJhQL6yOg@mail.gmail.com>
	<5515A9C8.6090400@Netapp.com>
	<CAHQdGtRaUYxU2JAAWErH7FT=Gy5JLzAKi-RtqqBSkNFZrhaB9Q@mail.gmail.com>
	<5515C1BF.8000907@Netapp.com> <20150327205414.GD27889@fieldses.org>
	<5515C3BE.3040807@Netapp.com> <20150327210839.GE27889@fieldses.org>
In-Reply-To: <20150327210839.GE27889@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, Marc Eshel <eshel@us.ibm.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-nfs-owner@vger.kernel.org

I just ran some more tests comparing the directio case across different filesystem types.  These tests used three 1G files:  100% data, 100% hole, and mixed file with alternating 4k data and hole segments.  The mixed case seems to be consistently slower compared to NFS v4.1, and I'm at a loss for anything I could do to make it faster.  Here are my numbers:

###########
#         #
#   XFS   #
#         #
###########


NFS v4.1:
                            Trial
|---------|---------|---------|---------|---------|---------|---------|
|         |    1    |    2    |    3    |    4    |    5    | Average |
|---------|---------|---------|---------|---------|---------|---------|
|    Data |  1.883s |  1.808s |  1.781s |  1.685s |  1.591s |  1.746s |
|    Hole |  1.815s |  1.635s |  1.682s |  1.698s |  1.653s |  1.697s |
|   Mixed |  2.089s |  2.024s |  1.970s |  1.925s |  2.049s |  2.011s |
|---------|---------|---------|---------|---------|---------|---------|


NFS v4.2:
                            Trial
|---------|---------|---------|---------|---------|---------|---------|
|         |    1    |    2    |    3    |    4    |    5    | Average |
|---------|---------|---------|---------|---------|---------|---------|
|    Data |  1.849s |  1.879s |  1.852s |  1.799s |  1.781s |  1.832s |
|    Hole |  0.668s |  0.600s |  0.611s |  0.619s |  0.617s |  0.623s |
|   Mixed |  5.913s |  5.811s |  5.952s |  5.962s |  5.806s |  5.889s |
|---------|---------|---------|---------|---------|---------|---------|





############
#          #
#   EXT4   #
#          #
############


NFS v4.1:
                            Trial
|---------|---------|---------|---------|---------|---------|---------|
|         |    1    |    2    |    3    |    4    |    5    | Average |
|---------|---------|---------|---------|---------|---------|---------|
|    Data |  2.637s |  1.823s |  1.792s |  1.816s |  2.000s |  2.014s |
|    Hole |  1.734s |  1.743s |  1.709s |  1.761s |  1.871s |  1.764s |
|   Mixed |  5.465s |  2.158s |  2.254s |  2.676s |  2.422s |  2.995s |
|---------|---------|---------|---------|---------|---------|---------|


NFS v4.2:
                            Trial
|---------|---------|---------|---------|---------|---------|---------|
|         |    1    |    2    |    3    |    4    |    5    | Average |
|---------|---------|---------|---------|---------|---------|---------|
|    Data |  1.934s |  1.783s |  1.800s |  2.010s |  1.982s |  1.902s |
|    Hole | 63.568s | 63.423s | 64.671s | 66.190s | 65.985s | 64.767s |
|   Mixed |  6.010s |  5.798s |  6.146s |  6.460s |  6.720s |  6.225s |
|---------|---------|---------|---------|---------|---------|---------|





#############
#           #
#   BTRFS   #
#           #
#############


NFS v4.1:
                            Trial
|---------|---------|---------|---------|---------|---------|---------|
|         |    1    |    2    |    3    |    4    |    5    | Average |
|---------|---------|---------|---------|---------|---------|---------|
|    Data |  2.386s |  1.952s |  1.832s |  1.818s |  1.826s |  1.963s |
|    Hole |  1.759s |  1.717s |  1.754s |  1.621s |  1.708s |  1.712s |
|   Mixed |  2.889s |  2.272s |  2.778s |  2.277s |  2.255s |  2.494s |
|---------|---------|---------|---------|---------|---------|---------|


NFS v4.2:
                            Trial
|---------|---------|---------|---------|---------|---------|---------|
|         |    1    |    2    |    3    |    4    |    5    | Average |
|---------|---------|---------|---------|---------|---------|---------|
|    Data |  2.586s |  1.816s |  2.022s |  1.862s |  1.975s |  2.052s |
|    Hole |  0.646s |  0.659s |  0.669s |  0.628s |  0.605s |  0.641s |
|   Mixed |  8.555s |  8.553s |  7.904s |  8.567s |  8.286s |  8.373s |
|---------|---------|---------|---------|---------|---------|---------|


On 03/27/2015 05:08 PM, J. Bruce Fields wrote:
> On Fri, Mar 27, 2015 at 04:55:26PM -0400, Anna Schumaker wrote:
>> On 03/27/2015 04:54 PM, J. Bruce Fields wrote:
>>> On Fri, Mar 27, 2015 at 04:46:55PM -0400, Anna Schumaker wrote:
>>>> On 03/27/2015 04:22 PM, Trond Myklebust wrote:
>>>>> On Fri, Mar 27, 2015 at 3:04 PM, Anna Schumaker
>>>>> <Anna.Schumaker@netapp.com> wrote:
>>>>>> I did two separate dd tests with the same 5G file from yesterday, and still using the same virtual machines.  First, I ran dd using direct IO for reads:
>>>>>>         dd if=/nfs/file iflag=direct of=/dev/null bs=128K
>>>>>>
>>>>>> Mixed file performance was awful, so I reran without direct IO enabled for comparison:
>>>>>>         dd if=/nfs/file iflag=nocache of=/dev/null oflag=nocache bs=128K
>>>>>>
>>>>>> bs=128K sets the block size used by dd to the NFS rsize, without this dd will only read 512 bytes at a time and take forever to complete.
>>>>>>
>>>>>>
>>>>>> ##########################
>>>>>> #                        #
>>>>>> #   Without READ_PLUS    #
>>>>>> #                        #
>>>>>> ##########################
>>>>>>
>>>>>>
>>>>>> NFS v4.1, iflag=direct:
>>>>>>                             Trial
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>> |         |    1    |    2    |    3    |    4    |    5    | Average |
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>> |    Data | 11.704s | 11.055s | 11.329s | 11.453s | 10.741s | 11.256s |
>>>>>> |    Hole |  9.839s |  9.326s |  9.381s |  9.430s |  8.875s |  9.370s |
>>>>>> |   Mixed | 19.150s | 19.468s | 18.650s | 18.537s | 19.312s | 19.023s |
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>
>>>>>>
>>>>>> NFS v4.2, iflag=direct:
>>>>>>                             Trial
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>> |         |    1    |    2    |    3    |    4    |    5    | Average |
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>> |    Data | 10.927s | 10.885s | 11.114s | 11.283s | 10.371s | 10.916s |
>>>>>> |    Hole |  9.515s |  9.039s |  9.116s |  8.867s |  8.905s |  9.088s |
>>>>>> |   Mixed | 19.149s | 18.656s | 19.400s | 18.834s | 20.041s | 19.216s |
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> NFS v4.1, iflag=nocache oflag=nocache:
>>>>>>                             Trial
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>> |         |    1    |    2    |    3    |    4    |    5    | Average |
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>> |    Data |  6.808s |  6.698s |  7.482s |  6.761s |  7.235s |  6.995s |
>>>>>> |    Hole |  5.350s |  5.148s |  5.161s |  5.070s |  5.089s |  5.164s |
>>>>>> |   Mixed |  9.316s |  8.731s |  9.072s |  9.145s |  8.627s |  8.978s |
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>
>>>>>>
>>>>>> NFS v4.2, iflag=nocache oflag=nocache:
>>>>>>                             Trial
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>> |         |    1    |    2    |    3    |    4    |    5    | Average |
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>> |    Data |  6.686s |  6.848s |  6.876s |  6.799s |  7.815s |  7.004s |
>>>>>> |    Hole |  5.092s |  5.330s |  5.050s |  5.280s |  5.030s |  5.156s |
>>>>>> |   Mixed |  8.142s |  7.897s |  8.040s |  7.960s |  8.050s |  8.018s |
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> #######################
>>>>>> #                     #
>>>>>> #   With READ_PLUS    #
>>>>>> #                     #
>>>>>> #######################
>>>>>>
>>>>>>
>>>>>> NFS v4.1, iflag=direct:
>>>>>>                             Trial
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>> |         |    1    |    2    |    3    |    4    |    5    | Average |
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>> |    Data |  9.464s | 10.181s | 10.048s |  9.452s | 10.795s |  9.988s |
>>>>>> |    Hole |  7.954s |  8.486s |  7.762s |  7.969s |  8.299s |  8.094s |
>>>>>> |   Mixed | 19.037s | 18.323s | 18.965s | 18.156s | 19.185s | 18.733s |
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>
>>>>>>
>>>>>> NFS v4.2, iflag=direct:
>>>>>>                             Trial
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>> |         |    1    |    2    |    3    |    4    |    5    | Average |
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>> |    Data | 11.923s | 10.026s | 10.222s | 12.387s | 11.431s | 11.198s |
>>>>>> |    Hole |  3.247s |  3.155s |  3.191s |  3.243s |  3.202s |  3.208s |
>>>>>> |   Mixed | 54.677s | 54.697s | 52.978s | 53.704s | 54.054s | 54.022s |
>>>>>
>>>>> That's a bit nasty. Any idea what is going on with the Mixed case here?
>>>>
>>>> Not offhand, but my first guess would be something to do with extra seeks to find how long each hole and data segment is.
>>>
>>> Remind us what "mixed" means?  (I think you were alternating, but how
>>> large is each segment?)
>>
>> "Mixed" is alternating 4K segments.
> 
> So it's probably doing 128/4 = 32 reads where previously one was
> necessary.  You could confirm that by looking at the READ counts in
> /proc/self/mountstats.  With odirect turned off maybe that's hidden by
> readahead?
> 
> --b.
> 
>>
>>>
>>> --b.
>>>
>>>>
>>>> Anna
>>>>
>>>>>
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> NFS v4.1, iflag=nocache oflag=nocache:
>>>>>>                             Trial
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>> |         |    1    |    2    |    3    |    4    |    5    | Average |
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>> |    Data |  6.788s |  6.802s |  6.750s |  6.756s |  6.852s |  6.790s |
>>>>>> |    Hole |  5.143s |  5.165s |  5.104s |  5.154s |  5.116s |  5.136s |
>>>>>> |   Mixed |  7.902s |  7.693s |  9.169s |  8.186s |  9.157s |  8.421s |
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>
>>>>>>
>>>>>> NFS v4.2, iflag=nocache oflag=nocache:
>>>>>>                             Trial
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>> |         |    1    |    2    |    3    |    4    |    5    | Average |
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>> |    Data |  6.897s |  6.862s |  7.054s |  6.961s |  7.081s |  6.971s |
>>>>>> |    Hole |  1.690s |  1.673s |  1.553s |  1.554s |  1.490s |  1.592s |
>>>>>> |   Mixed |  9.009s |  7.840s |  7.661s |  8.945s |  7.649s |  8.221s |
>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>
>>>>>>
>>>>>> On 03/26/2015 12:13 PM, Trond Myklebust wrote:
>>>>>>> On Thu, Mar 26, 2015 at 12:11 PM, Anna Schumaker
>>>>>>> <Anna.Schumaker@netapp.com> wrote:
>>>>>>>> On 03/26/2015 12:06 PM, Trond Myklebust wrote:
>>>>>>>>> On Thu, Mar 26, 2015 at 11:47 AM, Anna Schumaker
>>>>>>>>> <Anna.Schumaker@netapp.com> wrote:
>>>>>>>>>> On 03/26/2015 11:38 AM, J. Bruce Fields wrote:
>>>>>>>>>>> On Thu, Mar 26, 2015 at 11:32:25AM -0400, Trond Myklebust wrote:
>>>>>>>>>>>> On Thu, Mar 26, 2015 at 11:21 AM, Anna Schumaker
>>>>>>>>>>>> <Anna.Schumaker@netapp.com> wrote:
>>>>>>>>>>>>> Here are my updated numbers!  I tested with files 5G in size: one 100% data, one 100% hole, and one alternating between hole and data every 4K.  I collected data for both v4.1 and v4.2 with and without the READ_PLUS patches:
>>>>>>>>>>>>>
>>>>>>>>>>>>> ##########################
>>>>>>>>>>>>> #                        #
>>>>>>>>>>>>> #   Without READ_PLUS    #
>>>>>>>>>>>>> #                        #
>>>>>>>>>>>>> ##########################
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> NFS v4.1:
>>>>>>>>>>>>>                             Trial
>>>>>>>>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>>>>>>>> |         |    1    |    2    |    3    |    4    |    5    | Average |
>>>>>>>>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>>>>>>>> |    Data |  8.723s |  7.243s |  8.252s |  6.997s |  6.980s |  7.639s |
>>>>>>>>>>>>> |    Hole |  5.271s |  5.224s |  5.060s |  4.897s |  5.321s |  5.155s |
>>>>>>>>>>>>> |   Mixed |  8.050s | 10.057s |  7.919s |  8.060s |  9.557s |  8.729s |
>>>>>>>>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> NFS v4.2:
>>>>>>>>>>>>>                             Trial
>>>>>>>>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>>>>>>>> |         |    1    |    2    |    3    |    4    |    5    | Average |
>>>>>>>>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>>>>>>>> |    Data |  6.707s |  7.070s |  6.722s |  6.761s |  6.810s |  6.814s |
>>>>>>>>>>>>> |    Hole |  5.152s |  5.149s |  5.213s |  5.206s |  5.312s |  5.206s |
>>>>>>>>>>>>> |   Mixed |  7.979s |  7.985s |  8.177s |  7.772s |  8.280s |  8.039s |
>>>>>>>>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> #######################
>>>>>>>>>>>>> #                     #
>>>>>>>>>>>>> #   With READ_PLUS    #
>>>>>>>>>>>>> #                     #
>>>>>>>>>>>>> #######################
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> NFS v4.1:
>>>>>>>>>>>>>                             Trial
>>>>>>>>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>>>>>>>> |         |    1    |    2    |    3    |    4    |    5    | Average |
>>>>>>>>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>>>>>>>> |    Data |  9.082s |  7.008s |  7.116s |  6.771s |  7.902s |  7.576s |
>>>>>>>>>>>>> |    Hole |  5.333s |  5.358s |  5.380s |  5.161s |  5.282s |  5.303s |
>>>>>>>>>>>>> |   Mixed |  8.189s |  8.308s |  9.540s |  7.937s |  8.420s |  8.479s |
>>>>>>>>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> NFS v4.2:
>>>>>>>>>>>>>                             Trial
>>>>>>>>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>>>>>>>> |         |    1    |    2    |    3    |    4    |    5    | Average |
>>>>>>>>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>>>>>>>> |    Data |  7.033s |  6.829s |  7.025s |  6.873s |  7.134s |  6.979s |
>>>>>>>>>>>>> |    Hole |  1.794s |  1.800s |  1.905s |  1.811s |  1.725s |  1.807s |
>>>>>>>>>>>>> |   Mixed |  7.590s |  8.777s |  9.423s | 10.366s |  8.024s |  8.836s |
>>>>>>>>>>>>> |---------|---------|---------|---------|---------|---------|---------|
>>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> So there is a clear win in the 100% hole case here, but otherwise the
>>>>>>>>>>>> statistical fluctuations are dominating the numbers. Can you get us a
>>>>>>>>>>>> little more stats and then perhaps run the results through nfsometer?
>>>>>>>>>>>
>>>>>>>>>>> Also, could you describe the setup (are these still kvm's), and how
>>>>>>>>>>> you're clearing the cache between runs?
>>>>>>>>>>
>>>>>>>>>> These are still KVMs and my server is exporting an xfs filesystem.  I clear caches by running "echo 3 > /proc/sys/vm/drop_caches" on the server before every read, and I remount my client after reading each set of three files once.
>>>>>>>>>
>>>>>>>>> I agree that you have to use the 'drop_caches' interface on the
>>>>>>>>> server, but why not just use O_DIRECT on the clients?
>>>>>>>>
>>>>>>>> I've been reading by using cat from my test shell script: `time cat /nfs/file > /dev/null`.  I can write something to read files with O_DIRECT if that would be more useful!
>>>>>>>>
>>>>>>>
>>>>>>> 'dd' can do that for you if the appropriate incantations are performed.
>>>>>>>
>>>>>>
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>>
>>>>>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
